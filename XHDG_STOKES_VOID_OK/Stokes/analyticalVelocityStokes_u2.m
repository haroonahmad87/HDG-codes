function u2=analyticalVelocityStokes_u2(X)

u=analyticalVelocityStokes(X);
n=size(u,1);
u2=u(n/2+1:end);