classdef Support
   properties
      pos; % The coordinate 'X' where the force is applied. A 'positive' value 
      type; % The magnitude of the force
   end
   
   methods
      function obj = Support(_pos, _type)
         obj.pos = _pos;
         obj.type = _type;
      end
   end
end

