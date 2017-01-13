require_relative 'journey'

class JourneyLog

	attr_reader :active_journey, :entry_station, :journey_class

	def initialize(journey_class)
		@journey_class = journey_class
		@active_journey = journey_class.new
		@journeys = []
	end

	def start station
		current_journey.start_journey station
	end

	def finish station
		current_journey.finish_journey station
	end

	def journeys
		@journeys.dup
	end

	def current_journey
		@active_journey.complete? ? create_journey : @active_journey
	end
	private
	def create_journey
		@journeys << @active_journey
		@active_journey = journey_class.new
	end
end
