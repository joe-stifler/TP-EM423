classdef YoungModule
    properties
        Materials = {
            "Aluminum [69, , 95]",
            "Aluminum Alloys [70, , ]",
            "Copper [117, , 70]",
            "Concrete [17, , ]",
            "Gold [74, , ]",
            "Iridium [517, , ]",
            "Iron [210, , ]",
            "Nickel Steel [200, , ]",
            "Steel [, , ]",
            "Steel, AISI 302 [180, , ]",
            "Steel, ASTM-A36 [200, , ]",
            "Polyethylene PP [1.5, , ]",
            "Zinc [83, , ]",
            "Rubber [1e-3, 3e-4, ]",
            "Titanium [, , ]",
            "Wood [, , ]"
        }
        

        % Materials = {
        %     "Aluminum [25,5]",
        %     "Copper [63,4]",
        %     "Glass [26,2]",
        %     "Polyethylene [0,117]",
        %     "Rubber [0,0003]",
        %     "Steel [75,8]",
        %     "Titanium [41,4]",
        %     "Wood [4,0]"
        % }
        
        % Materials = {
        %     "Aluminum [69]",
        %     "Aluminum Alloys [70]",
        %     "Copper [117]",
        %     "Concrete [17]",
        %     "Gold [74]",
        %     "Iridium [517]",
        %     "Iron [210]",
        %     "Nickel Steel [200]",
        %     "Steel, AISI 302 [180]",
        %     "Steel, ASTM-A36 [200]",
        %     "Polyethylene PP [1.5]",
        %     "Zinc [83]"
        % }


        ValuesYoung = [
            69 * 1e9,
            70 * 1e9,
            117 * 1e9,
            17 * 1e9,
            74 * 1e9,
            517 * 1e9,
            210 * 1e9,
            200 * 1e9,
            180 * 1e9,
            200 * 1e9,
            1.5 * 1e9,
            83 * 1e9
        ]

        ValuesShear = [
            25.5 * 1e9,
            63.4 * 1e9,
            26.2 * 1e9,
            0.117 * 1e9,
            0.0003 * 1e9,
            75.8 * 1e9,
            41.4 * 1e9,
            4.0 * 1e9
        ]
    end
end