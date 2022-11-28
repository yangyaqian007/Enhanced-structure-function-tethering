%% null distribution(10000 realisations) (discard)
core=20;
p=parpool(core);
p.IdleTimeout=10000;
parfor i=1:core
    null_distribution_Sc(i) ;
end
delete(p)
