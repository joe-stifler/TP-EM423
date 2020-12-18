classdef YoungModule
    properties
        Materials = {
            "Aluminum [69]",
            "Aluminum Alloys [70]",
            "Copper [117]",
            "Concrete [17]",
            "Gold [74]",
            "Iridium [517]",
            "Iron [210]",
            "Nickel Steel [200]",
            "Steel, AISI 302 [180]",
            "Steel, ASTM-A36 [200]",
            "Polyethylene PP [1.5]",
            "Zinc [83]"
        }

        Values = [
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
    end
end