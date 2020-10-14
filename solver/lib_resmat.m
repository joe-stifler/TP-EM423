classdef    lib_resmat 
    methods ( Static = true )
        function [v_forces, h_forces, t_forces, m_forces, v_dist_forces] = res_mat_1d_solver(
                beam_width,
                vertical_forces,
                horizontal_forces,
                torques,
                vertical_dist_forces,
                supports
            )
        
            % if there is no support present, then there is nothing to do
            if length(supports) == 1
                t_forces = Force(0, 0);
                m_forces(1) = Force(0, 0);
                v_forces = Force(0, 0);
                h_forces = Force(0, 0);

                printf("No support specified! Returning from function without solving the problem.")
                
                return
            end

            t_forces = torques;
            m_forces(1) = Force(0, 0);
            v_dist_forces(1) = Force(0, 0);
            v_forces = vertical_forces;
            h_forces = horizontal_forces;
        
            % Converts the distributed forces to punctual forces
            for i = 2:length(vertical_dist_forces)
                dist_force = vertical_dist_forces(i);
                
                % calculates the resultant force (integrates from `beg` to `end`)
                result_force = quadcc(@(x) (dist_force.dist_func(x) + 0 * x), dist_force.pos_beg, dist_force.pos_end);
        
                % calculates the centroid of the force (integrates from `beg` to `end`)
                centroid = quadcc(@(x) (dist_force.dist_func_times_x(x) + 0 * x), dist_force.pos_beg, dist_force.pos_end) / result_force;
                
                % add the punctual forces to the end of the vertical forces vector
                v_dist_forces(length(v_dist_forces) + 1) = Force(centroid, result_force);
                vertical_forces(length(vertical_forces) + 1) = Force(centroid, result_force);
            end
        
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
            
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Roller support force decomposition
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if _support.type == SupportType().Roller
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Vertical Force decomposition (and consequently the generation of momentum due to the vertical force)
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the vertical (and its momentum) incognita column
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = beam_width - _support.pos;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (beam_width - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;

                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Pinned support force decomposition
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    elseif _support.type == SupportType().Pinned
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Torque Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the torque incognita column
                            A(3, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            t_forces(length(t_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Horizontal Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the horizontal incognita column
                            A(2, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            h_forces(length(h_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end
                        
                        num_incognitas = num_incognitas + 1;
            
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Vertical Force decomposition (and consequently the generation of momentum due to the vertical force)
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the vertical (and its momentum) incognita column
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = beam_width - _support.pos;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (beam_width - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    % Fixed support force decomposition
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    elseif _support.type == SupportType().Fixed
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Torque Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the torque incognita column
                            A(3, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            t_forces(length(t_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;

                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Horizontal Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the horizontal incognita column
                            A(2, num_incognitas + 1) = 1;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            h_forces(length(h_forces) + 1) = Force(0, X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
                        
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Vertical Force decomposition (and consequently the generation of momentum due to the vertical force)
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if loopIdx == 1
                            % We construct the coefficient matrix for the vertical (and its momentum) incognita column
                            A(1, num_incognitas + 1) = 1;
                            A(4, num_incognitas + 1) = beam_width - _support.pos;
                        else
                            % Assumes that we already evaluate `X` through the linear system solution
                            v_forces(length(v_forces) + 1) = Force(_support.pos, X(num_incognitas + 1));
                            m_forces(length(m_forces) + 1) = Force(_support.pos, (beam_width - _support.pos) * X(num_incognitas + 1));
                        end

                        num_incognitas = num_incognitas + 1;
            
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        % Momentum Force decomposition
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
