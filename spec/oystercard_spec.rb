require 'oystercard'

describe Oystercard do

let(:entry_station) 		{double(:station)}
let(:exit_station)	{double(:station)}
let(:journey){ {entry_station: entry_station, exit_station: exit_station} }
# let(:journey_log) {double(:journey_log),
# 	                 new: nil,
# 								   start: nil,
# 								 	 finish: nil}

	it { is_expected.to respond_to(:touch_in).with(1).argument }
	it { is_expected.to respond_to(:journeys) }

	it "journey history should be empty by default" do
		expect(subject.journeys).to be_empty
	end

	context "Completed journeys" do
		before(:each) do
			subject.top_up(Oystercard::CARD_LIMIT)
			subject.touch_in(entry_station)
			subject.touch_out(exit_station)
		end

		it "stores exit station" do
			expect(subject.journeys[0][:exit_station]).to eq exit_station
		end

		it "should remember previous journeys" do
			expect(subject.journeys).to include journey
		end
	end

	context 'Card has been topped up' do
		before (:each) do
			subject.top_up(Oystercard::CARD_LIMIT)
		end

		describe '#top_up' do
			it "should error for attempted top ups greater than pre-specified limit" do

				expect {subject.top_up(1)}.to raise_error "Top Up Error: You have hit your top up limit of #{Oystercard::CARD_LIMIT}"
			end

		end

		describe '#touch_out' do

			it "should deduct fare at touch out" do
				subject.touch_in(entry_station)
				expect{subject.touch_out(exit_station)}.to change {subject.balance}.by -(Oystercard::MINIMUM_FARE)
			end

		end
	end

	it { is_expected.to respond_to(:balance) }

	it "should have a starting balance of 0" do
		expect(subject.balance).to eq 0
	end

	it "should have a constant card limit of 90" do

		expect(Oystercard::CARD_LIMIT).to eq (90)

	end

	describe '#top_up' do

		it { is_expected.to respond_to(:top_up).with(1).argument }

		it "should update card balance" do
			expect{subject.top_up 1}.to change {subject.balance}.by 1
		end

	end

	describe '#touch_in' do

		it { is_expected.to respond_to(:touch_in) }


		it "should raise an error when balance below minimum fare" do
			expect{subject.touch_in(entry_station)}.to raise_error("Insufficient funds")
		end

		it "should charge a penalty fare if previous journey incomplete" do
			subject.top_up(Oystercard::CARD_LIMIT)
			subject.touch_in(entry_station)
			expect{subject.touch_in(entry_station)}.to change {subject.balance}.by -6
		end

	end

	describe '#touch_out' do

		it { is_expected.to respond_to(:touch_out) }


	end

end
