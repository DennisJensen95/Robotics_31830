function q=J_path(t_sim)

global GM t_sek

t_sek=2;
sek_nr=ceil(t_sim/t_sek+1e-99);
t=t_sim-(sek_nr-1)*t_sek;

link_nr=1;
i=(sek_nr-1)*4+link_nr;
q(link_nr)=GM(i,1)*t^5+GM(i,2)*t^4+GM(i,3)*t^3+GM(i,4)*t^2+GM(i,5)*t+GM(i,6);

link_nr=2;
i=(sek_nr-1)*4+link_nr;
q(link_nr)=GM(i,1)*t^5+GM(i,2)*t^4+GM(i,3)*t^3+GM(i,4)*t^2+GM(i,5)*t+GM(i,6);

link_nr=3;
i=(sek_nr-1)*4+link_nr;
q(link_nr)=GM(i,1)*t^5+GM(i,2)*t^4+GM(i,3)*t^3+GM(i,4)*t^2+GM(i,5)*t+GM(i,6);

link_nr=4;
i=(sek_nr-1)*4+link_nr;
q(link_nr)=GM(i,1)*t^5+GM(i,2)*t^4+GM(i,3)*t^3+GM(i,4)*t^2+GM(i,5)*t+GM(i,6);
