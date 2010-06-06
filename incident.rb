class MatchIncident
  attr_accessor :type, :minutes, :person, :country

  def initialize(value)
    # Set defaults
    @type = IncidentType::UNKNOWN
    @minutes = 0
    @person = 'Andrews'
    @country = 'England'

    @value = value
    determineType()
    determineCountry()
    determineMinutes()
    determinePerson()
  end

  # All methods below this point are private
  private

  # What country scored/had a player sent off?
  def determineCountry
    @country = 'England'
  end

  # When did the Incident happen?
  def determineMinutes
    if @type == IncidentType::HALF_TIME
      @minutes = 45
    elsif @type == IncidentType::FULL_TIME
      @minutes = 90
    elsif @type == IncidentType::GOAL
      mins = @value.search("strong[@class='minutesIntoMatch']")
      if mins.any?
        @minutes = mins[0].inner_html.strip
      end
    end
  end


  # Who was involved in the incident?
  def determinePerson
    @person = 'Andrews'
  end

  # What was the type of incident
  def determineType
    html = @value.inner_html
    id = @value.attributes['id']

    if html.include? 'GOAL: '
      @type = IncidentType::GOAL
    elsif id.include? '_HalfTime'
      @type = IncidentType::HALF_TIME
    elsif id.include? '_FullTime'
      @type = IncidentType::FULL_TIME
    elsif html.include? 'SENT OFF:'
      @type = IncidentType::SENT_OFF
    end
  end

end

class IncidentType
  GOAL      = 1
  SENT_OFF  = 2
  HALF_TIME = 3
  FULL_TIME = 4
  UNKNOWN   = 5
end

