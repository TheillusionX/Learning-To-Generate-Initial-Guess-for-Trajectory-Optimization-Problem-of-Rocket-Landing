function [c_out,ceq] = nonlcon(x)

global N time_array XI_MAT Cap_PSI_MAT

GS_Theta_max = 86*(pi/180); %% w.r.t Vertical

for k_GS=1:1:N
    t_k_GS = time_array(k_GS);
    XI_k = XI_MAT((k_GS-1)*7+1:7*(k_GS),1);
    Cap_PSI_k = Cap_PSI_MAT((k_GS-1)*7+1:7*(k_GS),:);
    S_MAT = [0, 1, 0, 0, 0, 0, 0;
             0, 0, 1, 0, 0, 0, 0];
    C_Vector = [tan(GS_Theta_max), 0, 0, 0, 0, 0, 0];
    %%%%%%%%%%%
    A_SOC_GS = S_MAT*Cap_PSI_k;
    b_SOC_GS = -S_MAT*XI_k;
    d_SOC_GS = C_Vector*Cap_PSI_k; %% zero
    gamma_SOC_GS = -C_Vector*XI_k;
    %socConstraints_GS(k_GS) = secondordercone(A_SOC_GS,b_SOC_GS,d_SOC_GS,gamma_SOC_GS);
    c_GS(k_GS) = norm(A_SOC_GS*x - b_SOC_GS) - d_SOC_GS*x + gamma_SOC_GS;
end

global e_Sigma
E_U = [eye(3), zeros(3,1)];
for k_norm=1:1:N
    Cap_Gamma_k = zeros(4,4*(N));
    Cap_Gamma_k(:,(k_norm-1)*4+1:4*(k_norm)) = eye(4,4);

    A_SOC = E_U*Cap_Gamma_k;
    b_SOC = zeros(3,1); %% zero
    d_SOC = (e_Sigma*Cap_Gamma_k)';
    gamma_SOC = 0; %% zero
    
    %socConstraints_NormU(k_norm) = secondordercone(A_SOC,b_SOC,d_SOC,gamma_SOC);
    c_NU(k_norm) = norm(A_SOC*x - b_SOC) - d_SOC'*x + gamma_SOC;
end

c = [c_GS,c_NU];
ceq = [];
c_out = c';

end