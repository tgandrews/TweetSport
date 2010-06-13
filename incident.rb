# Example data:
#<li id="footballVideprinter_match_3253942_event_13267446">GOAL: <strong>Portugal 1-</strong>0 Mozambique : <strong>Danny</strong><strong class="minutesIntoMatch"> (52)</strong></li>

class MatchIncident
    attr_accessor :type, :minutes, :person, :country, :matchid

    def initialize(value)
        # Set defaults
        @type = IncidentType::UNKNOWN
        @minutes = 0
        @person = 'N/A'
        @country = 'N/A'
        @matchid = 0

        @value = value
        # Calculate the rest
        determineType
        determineMinutes
        determineMatchID
    end

    # All methods below this point are private
    private

    # What was the type of incident
    def determineType
        html = @value.inner_html
        id = @value.attributes['id']

        if html.include? 'GOAL: '
            @type = IncidentType::GOAL
            countrySpecificIncidents
        elsif id.include? '_HalfTime'
            @type = IncidentType::HALF_TIME
        elsif id.include? '_FullTime'
            @type = IncidentType::FULL_TIME
        elsif id.include? '_Result'
            @type = IncidentType::RESULT
        elsif html.include? 'SENT OFF:'
            @type = IncidentType::SENT_OFF
            countrySpecificIncidents
        end
    end

    # Some values only make sense for certain incidents
    # TODO: OOP - Make them a sub class
    def countrySpecificIncidents
        determinePerson
        determineCountry
    end

    # What country scored/had a player sent off?
    def determineCountry
        if @type == IncidentType::GOAL
            # Remove the current score - we can calculate this
            # TODO: Store this for later for validation
            unclean = @value.search("strong[1]").inner_html.strip
            @country = unclean.gsub(/\d+-/,'')
        elsif @type == IncidentType::SENT_OFF
            @country = @value.inner_html.split(',')[0].gsub('SENT OFF:','').strip
        end
    end

    # When did the incident happen?
    def determineMinutes
        if @type == IncidentType::HALF_TIME
            @minutes = 45
        elsif @type == IncidentType::FULL_TIME
            @minutes = 90
        elsif @type == IncidentType::GOAL
            mins = @value.search("strong[@class='minutesIntoMatch']")
            if mins.any?
                @minutes = mins[0].inner_html.strip.scan(/\d+/)
            end
        end
    end

    # Who was involved in the incident?
    def determinePerson
        if @type == IncidentType::GOAL
            @person = @value.search("strong[2]").inner_html
        elsif @type == IncidentType::SENT_OFF
            @person = @value.inner_html.split(',')[1].strip
        end
    end

    # The BBC ID of the match
    def determineMatchID
        @matchid = @value.get_attribute('id').split('_')[2]
    end
end

class IncidentType
    GOAL      = 'GOAL'
    SENT_OFF  = 'SENT_OFF'
    HALF_TIME = 'HALF_TIME'
    FULL_TIME = 'FULL_TIME'
    RESULT    = 'RESULT'
    UNKNOWN   = 'UNKNOWN'
end
