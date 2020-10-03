classdef DistForce
   properties
      pos_beg;
      pos_end;
      dist_func; % The magnitude of the force
   end
   
   methods
      function obj = DistForce(_pos_beg, _pos_end, _dist_func)
         obj.pos_beg = _pos_beg;
         obj.pos_end = _pos_end;
         obj.dist_func = _dist_func;
      end
   end
end

