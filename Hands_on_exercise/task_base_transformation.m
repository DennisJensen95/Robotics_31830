function R = task_base_transformation(P0, Px, Py)
% calculate rotation matrix from task to base system
% input: P0, Px, Py as column vectors

    vx = (Px - P0)/norm(Px-P0);
    vy = (Py - P0)/norm(Py-P0);
    vz = cross(vx,vy);
    
    R = [vx, vy ,vz];  

end