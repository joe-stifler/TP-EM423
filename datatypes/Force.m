classdef Force
   properties
      pos; 
      mag; % The magnitude of the force
   end
   
   methods
      function obj = Force(_pos, _mag)
         obj.pos = _pos;
         obj.mag = _mag;
      end
   end
end

