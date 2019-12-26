for i = 1:30
    for j = 1:13
        if isreal(rm1(i,j).dam_t_u)
            paper.form2(1).val(i,j) = rm1(i,j).dam_t_u;
        else
            paper.form2(1).val(i,j) = nan;
        end
    end
end

for i = 1:30
    for j = 1:13
        if isreal(rm2(i,j).dam_t_u)
            paper.form2(2).val(i,j) = rm2(i,j).dam_t_u;
        else
            paper.form2(2).val(i,j) = nan;
        end
    end
end

for i = 1:30
    for j = 1:17
        if isreal(rm3(i,j).dam_t_u)
            paper.form2(3).val(i,j) = rm3(i,j).dam_t_u;
        else
            paper.form2(3).val(i,j) = nan;
        end
    end
end

for i = 1:30
    for j = 1:11
        if isreal(rs1(i,j).dam_t_u)
            paper.form(1).val(i,j) = rs1(i,j).dam_t_u;
        else
            paper.form(1).val(i,j) = 0;
        end
    end
end