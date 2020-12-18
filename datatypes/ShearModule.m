classdef ShearModule
   properties
        Materials = {
            "Aluminum [25,5]",
            "Copper [63,4]",
            "Glass [26,2]",
            "Polyethylene [0,117]",
            "Rubber [0,0003]",
            "Steel [75,8]",
            "Titanium [41,4]",
            "Wood [4,0]"
        }

        Values = [
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