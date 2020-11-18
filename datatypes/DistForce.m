classdef DistForce
   properties
      pos_beg;
      pos_end;
      poly_func;
   end
   
   methods
      function obj = DistForce(_pos_beg, _pos_end, _poly_func)
         obj.pos_beg = _pos_beg;
         obj.pos_end = _pos_end;
         
         splitval = strsplit(_poly_func, ',');

         obj.poly_func = zeros(1, length(splitval));

         for i = 1:length(splitval)
            obj.poly_func(i) = str2double(splitval(i));
         end
      end
   end
end

