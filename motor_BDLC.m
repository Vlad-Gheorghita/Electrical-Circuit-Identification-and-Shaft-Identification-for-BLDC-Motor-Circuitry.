load('gheorghita.mat')
close all;
clc;

t=double(gheorghita.X.Data)';
d=double(gheorghita.Y(1,3).Data)';
w=double(gheorghita.Y(1,2).Data)'; %viteza unghiulara;
th=double(gheorghita.Y(1,1).Data)'; %pozitia unghiulara;

figure;
subplot(311); plot(t,d); title('Intrarea d');
subplot(312); plot(t,w); title('Viteza unghiulara w');
subplot(313); plot(t,th); title('Pozitia unghiulara th');

i1=1130; i2=1400; i3=4866; i4=5131; i5=8660; i6=8964;

wi=w;
wi(i1:i2)=interp1([t(i1) t(i2)],[w(i1) w(i2)], t(i1:i2));
wi(i3:i4)=interp1([t(i3) t(i4)],[w(i3) w(i4)], t(i3:i4));
wi(i5:i6)=interp1([t(i5) t(i6)],[w(i5) w(i6)], t(i5:i6));
w=wi;

figure;
subplot(311); plot(t,d); title('Intrarea d');
subplot(312); plot(t,w); title('Viteza unghiulara w'); grid;
subplot(313); plot(t,th); title('Pozitia unghiulara th');

i1_dec=2981; i2_dec=3130;
N=i2_dec-i1_dec+1;

Te=t(2)-t(1);
Te_dec=Te*N;

t_dec=t(1:N:end);
d_dec=d(1:N:end);
w_dec=w(1:N:end);
th_dec=th(1:N:end);

% figure;
% plot(t_dec,w_dec);



%normal:
t1=1426; t2=4786; t3=5153; t4=8639;
data_id_w=iddata(w(t1:t2),d(t1:t2),Te);
data_id_th=iddata(th(t1:t2),w(t1:t2),Te);

data_v_w=iddata(w(t3:t4),d(t3:t4),Te);
data_v_th=iddata(th(t3:t4),w(t3:t4),Te);

data_g_w=iddata(w,d,Te);
data_g_th=iddata(th,w,Te);


%d->th:
% data_id_dth=iddata(th(t1:t2),d(t1:t2),Te);
% data_v_dth=iddata(th(t3:t4),d(t3:t4),Te);
% data_g_dth=iddata(th,d,Te);

%decimare:
% t1=10; t2=30; t3=36; t4=56;
% data_id_w_dec=iddata(w_dec(t1:t2),d_dec(t1:t2),Te_dec);
% data_id_th_dec=iddata(th_dec(t1:t2),w_dec(t1:t2),Te_dec);
% 
% data_v_w_dec=iddata(w_dec(t3:t4),d_dec(t3:t4),Te_dec);
% data_v_th_dec=iddata(th_dec(t3:t4),w_dec(t3:t4),Te_dec);
% 
% data_g_w_dec=iddata(w_dec,d_dec,Te_dec);
% data_g_th_dec=iddata(th_dec,w_dec,Te_dec);

%PEM:
% data_id=iddata([th(t1:t2) w(t1:t2)],d(t1:t2),Te); %
% data_v=iddata([th(t3:t4) w(t3:t4)],d(t3:t4),Te);  % Spatiul starilor
% data_g=iddata([th w],d,Te);

%% ARX------------------------------------------------
close all;
clc;

m_arx_w=arx(data_id_w, [1 1 1]);    %
m_arx_th=arx(data_id_th, [1 1 1]);  % [na,nb,nd]

figure;
resid(m_arx_w, data_v_w,'corr',5);
figure;
compare(m_arx_w, data_g_w);

figure;
resid(m_arx_th, data_v_th,'corr',5);
figure;
compare(m_arx_th, data_g_th);

% d->th

% m_arx_dth=arx(data_id_dth, [1 1 1]);  % [na,nb,nd]
% 
% figure;
% resid(m_arx_dth, data_v_dth);
% figure;
% compare(m_arx_dth, data_g_dth);

%% ARMAX------------------------------------------------------------
close all;
clc;

m_armax_w=armax(data_id_w, [1 1 1 1]);  %
m_armax_th=armax(data_id_th, [1 1 1 1]);% [na,nb,nc,nd]

figure; resid(m_armax_w, data_v_w);
figure; compare(m_armax_w, data_g_w);

figure; resid(m_armax_th, data_v_th);
figure; compare(m_armax_th, data_g_th);


%% IV----------------------------------------------------------------
close all;
clc;

m_iv_w=iv4(data_id_w, [1 1 1]);     %
m_iv_th=iv4(data_id_th, [1 1 1]);   %[na,nb,nd]

figure; resid(m_iv_w, data_v_w);
figure; compare(m_iv_w, data_g_w);

figure; resid(m_iv_th, data_v_th);
figure; compare(m_iv_th, data_g_th);


%% OE------------------------------------------------------------------
close all;
clc;

m_oe_w=oe(data_id_w, [1 1 1]);      %
m_oe_th=oe(data_id_th, [1 1 1]);    % [na,nb,nd]

figure; resid(m_oe_w, data_v_w,'corr',5);
figure; compare(m_oe_w, data_g_w);

figure; resid(m_oe_th, data_v_th);
figure; compare(m_oe_th, data_g_th);


%% ARX+PEM--------------------------------------------------------------
close all;
clc;

m_arx_th_pem=pem(data_id_th,m_arx_th);

figure;
resid(m_arx_th_pem,data_v_th);
figure;
compare(m_arx_th_pem,data_g_th);


%% N4SID-------------------------------------------------------
close all;
clc;

m_n4sid_w=n4sid(data_id_w,1);
m_n4sid_th=n4sid(data_id_th,1);

figure;
resid(m_n4sid_w,data_v_w);
figure;
compare(m_n4sid_w,data_g_w);

figure;
resid(m_n4sid_th,data_v_th);
figure;
compare(m_n4sid_th, data_g_th);


%% SSEST------------------------------------------------------------
close all;
clc;


m_ssest_w=ssest(data_id_w,1);
m_ssest_th=ssest(data_id_th,1);

figure;
resid(m_ssest_w,data_v_w);
figure;
compare(m_ssest_w,data_g_w);

figure;
resid(m_ssest_th,data_v_th);
figure;
compare(m_ssest_th,data_g_th);


%% ARX+dec-----------------------------------------------------
close all;
clc;

m_arx_w_dec=arx(data_id_w_dec, [1 1 1]);    %
m_arx_th_dec=arx(data_id_th_dec, [1 1 1]);  % [na,nb,nd]


figure;
resid(m_arx_w_dec, data_v_w_dec);
figure;
compare(m_arx_w_dec, data_g_w_dec);

figure;
resid(m_arx_th_dec, data_v_th_dec);
figure;
compare(m_arx_th_dec, data_g_th_dec);


%% PEM--------------------------------------------------------------
close all;
clc;

M_pem=pem(data_id);
figure;
resid(M_pem,data_v);
figure;
compare(M_pem,data_g);
%% Se alege metoda optima(In cazul nostru "OE") si se afla tf-----------
close all;
clc;

Hd_oe_w_d=tf(m_oe_w);
Hd_oe_th_w=tf(m_oe_th);

Ki=0.002028/Te; %unde 0.002028 coeficientul numaratorului de la Hd_oe_th

H_oe_w_d=d2c(Hd_oe_w_d, 'zoh')
H_oe_th_w=tf(Ki, [1 0])

H_th_d=series(H_oe_th_w, H_oe_w_d)

