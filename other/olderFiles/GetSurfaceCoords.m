function R =  GetSurfaceCoords(Coords)
    
    indices_to_dump = [];
    R = Coords;
    for i=1:length(R)
        x=R(i,1);
        y=R(i,2);
        z_idx = (find(R(:,1)==x & R(:,2)==y));
        m1=min(R(z_idx,3));
        m2=max(R(z_idx,3));
        z_idx_new1 = z_idx(R(z_idx,1) == x & R(z_idx,2)==y & R(z_idx,3) ~= m1);
        z_idx_new2 = z_idx_new1(R(z_idx_new1,1) == x & R(z_idx_new1,2)==y & R(z_idx_new1,3) ~= m2);
        indices_to_dump = [indices_to_dump;z_idx_new2];
        clear z_idx z_idx_new1 z_idx_new2;
    end
    R(indices_to_dump,:) = [];
end