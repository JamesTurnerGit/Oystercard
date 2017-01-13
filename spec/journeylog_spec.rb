require 'journeylog'

describe JourneyLog do
  subject(:journeylog){described_class.new(journey_class)}
  let(:journey_class) {double :journey,new: journey}
  let(:journey) {double :journey,
                complete?: false,
                current_journey: {},
                start_journey: nil,
                finish_journey: nil}
  let(:journey_new) {double :journey_new,complete?: false}
  let(:start_station) {double :start_station}
  let(:end_station) {double :end_station}


  describe "#creation " do
    it 'should have journey_class parameter' do
      expect(journeylog.active_journey).to eq journey
    end
    it 'should return an empty array if no journeys have happened' do
      expect(subject.journeys.size).to eq 0
    end
  end

  describe '#start ' do
    it 'should start a new journey' do
      subject.start start_station
      expect(journey).to have_received(:start_journey).with(start_station)
    end
  end

  describe '#finish ' do
    it  'should add an exit station to current_journey' do
      subject.start start_station
      subject.finish end_station
      expect(journey).to have_received(:finish_journey).with(end_station)
    end
  end

  describe '#current_journey ' do
    it 'should return a current journey if one exists ' do
      expect(subject.current_journey).to eq journey
    end
    it 'should create a new journey if current journey is complete ' do
      allow(journey).to receive(:complete?).and_return(true)
      allow(journey_class).to receive(:new).and_return(journey_new)
      expect(subject.current_journey).to eq journey_new
    end
  end

  describe '#journeys ' do
    it 'should return a list of all previous journeys without exposing the internal array' do
      subject.journeys << "Bill"
      expect(subject.journeys).not_to include("Bill")
    end
  end
end
