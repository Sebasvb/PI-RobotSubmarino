function [PX,GX,Xe,Xp] = KalmaFilterF(pos, PX, vP, varposX,Xe,Xp)
    PcX = PX + vP;
    GX = (PcX)/((PcX) + varposX); %%Ganacia de kalman para X
    PX = (1-GX)*PcX;    
    Xp = Xe; Zp = Xp;
    Xe = GX*(pos-Zp)+Xp;
 end