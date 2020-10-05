classdef    lib_resmat 
    methods ( Static = true )
        function [v_forces, h_forces, t_forces, m_forces] = res_mat_1d_solver(
                beam_width,
                vertical_forces,
                horizontal_forces,
                torques,
                vertical_dist_forces,
                supports
            )
        
            % if there is no support, then there is nothing to do
            if length(supports) == 1
                alfa = 0
                return
            end
        
            % Converts the distributed forces to punctual forces
            for i = 2:length(vertical_dist_forces)
                dist_force = vertical_dist_forces(i);
                
                % calculates the resultant force (integrates from `beg` to `end`)
                result_force = quadcc(dist_force.dist_func, dist_force.pos_beg, dist_force.pos_end);
        
                func_x = @(x) x .* dist_force.dist_func(x);
        
                % calculates the centroid of the force (integrates from `beg` to `end`)
                centroid = quadcc(func_x, dist_force.pos_beg, dist_force.pos_end) / result_force;
        
                % add the punctual forces to the end of the vertical forces vector
                vertical_forces(length(vertical_forces) + 1) = Force(centroid, result_force);
            end

            t_forces = torques;
            m_forces(1) = Force(0, 0);
            v_forces = vertical_forces;
            h_forces = horizontal_forces;
        
            % calculates the resultant vertical and horizontal forces, as well the resultant torques
            sum_torque_forces = 0;
            sum_vertical_forces = 0;
            sum_momentums_forces = 0;
            sum_horizontal_forces = 0;
        
            % resultant torques
            for i = 2:length(torques)
                sum_torque_forces = sum_torque_forces + torques(i).mag;
            end
        
            % resultant vertical forces
            for i = 2:length(vertical_forces)
                force = vertical_forces(i);
        
                sum_vertical_forces = sum_vertical_forces + force.mag;
                sum_momentums_forces = sum_momentums_forces + (beam_width - force.pos) * force.mag;

                m_forces(length(m_forces) + 1) = Force(force.pos, (beam_width - force.pos) * force.mag);
            end
        
            % resultant horizontal forces
            for i = 2:length(horizontal_forces)
                sum_horizontal_forces = sum_horizontal_forces + horizontal_forces(i).mag;
            end
        
            B = [
                -sum_vertical_forces;
                -sum_horizontal_forces;
                -sum_torque_forces;
                -sum_momentums_forces
            ];
        
            torque_incognitas(1) = Force(0, 0);
            momentum_ingonitas(1) = Force(0, 0);
            vertical_ingonitas(1) = Force(0, 0);
            horizontal_ingonitas(1) = Force(0, 0);
        
            num_incognitas = 0;
        
            for i = 2:length(supports)
                _support = supports(i);
        
                if _support.type == SupportType().Roller
                    num_incognitas = num_incognitas + 1;
                elseif _support.type == SupportType().Pinned
                    num_incognitas = num_incognitas + 3;
                elseif _support.type == SupportType().Fixed
                    num_incognitas = num_incognitas + 4;
                end
            end
        
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % line 1: vertical forces equilibrium       %
            % line 2: horizontal forces equilibrium     %
            % line 3: torques forces equilibrium        %
            % line 4: momemtum forces equilibrium       %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % column X: represents the X incognita      %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            X = zeros(num_incognitas);
            A = zeros(4, num_incognitas);

            for loopIdx = 1:2
                num_incognitas = 0;

                for i = 2:length(supports)
                    _support = supports(i);
            
                    if _support.type == SupportType().Roller
                        if loopIdx == 1
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = beam_width - _support.pos;
                        else
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (beam_width - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;

                    elseif _support.type == SupportType().Pinned
                        
                        if loopIdx == 1
                            A(3, num_incognitas + 1) = 1;
                        else
                            t_forces(length(t_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                        if loopIdx == 1
                            A(2, num_incognitas + 1) = 1;
                        else
                            h_forces(length(h_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end
                        
                        num_incognitas = num_incognitas + 1;
            
                        if loopIdx == 1
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = beam_width - _support.pos;
                        else
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (beam_width - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                    elseif _support.type == SupportType().Fixed
                    
                        if loopIdx == 1
                            A(3, num_incognitas + 1) = 1;
                        else
                            t_forces(length(t_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;

                        if loopIdx == 1
                            A(2, num_incognitas + 1) = 1;
                        else
                            h_forces(length(h_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
                        
                        if loopIdx == 1
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = beam_width - _support.pos;
                        else
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (beam_width - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                        if loopIdx == 1
                            A(4, num_incognitas + 1) = 1;
                        else
                            m_forces(length(m_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                        end
                        
                        num_incognitas = num_incognitas + 1;
                    end
                end

                if loopIdx == 1
                    X = A \ B;
                end
            end
        end
    
    end
end
