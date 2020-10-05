classdef DistForce
   properties
      pos_beg;
      pos_end;
      dist_func;
      dist_func_times_x;
   end
   
   methods
      function obj = DistForce(_pos_beg, _pos_end, _dist_func, _dist_func_times_x)
         obj.pos_beg = _pos_beg;
         obj.pos_end = _pos_end;
         obj.dist_func = _dist_func;
         obj.dist_func_times_x = _dist_func_times_x;
      end
   end
end

