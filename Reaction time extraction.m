
subjectdata.subjectdir        = 'C:\MyTemp\data';
subjectdata.datadir         =  {'ID_103_RAW.set', 'ID_105_RAW.set','ID_108_RAW.set','ID_113_RAW.set','ID_114_RAW.set','ID_119_RAW.set','ID_126_RAW.set','ID_130_RAW.set','ID_147_RAW.set','ID_151_RAW.set','ID_152_RAW.set','ID_161_RAW.set','ID_166_RAW.set','ID_167_RAW.set','ID_174_RAW.set','ID_179_RAW.set','ID_180_RAW.set','ID_181_RAW.set','ID_185_RAW.set','ID_186_RAW.set','ID_188_RAW.set','ID_190_RAW.set','ID_197_RAW.set','ID_198_RAW.set','ID_206_RAW.set','ID_214_RAW.set','ID_216_RAW.set','ID_218_RAW.set','ID_244_RAW.set','ID_251_RAW.set','ID_258_RAW.set'};
subjectdata.datanr = {'103','105','108','113','114','119','126','130','147','151','152','161','166','167','174','179','180','181','185','186','188','190','197','198','206','214','216','218','244','251','258'};
% subjectdata.conditions = {'11', '12', '13','14', {'21' '23' '25' '27'}, {'22' '24' '26' '28'}};


for k = 1:31
    
    cfg = [];
    cfg.dataset  = [subjectdata.subjectdir filesep subjectdata.datadir{1,k}];
    event = ft_read_event(cfg.dataset);
    
    
    newField =  ['event' num2str(subjectdata.datanr{1,k})];
    [t.(newField)]= ft_read_event(cfg.dataset);
    
     writetable(struct2table(t.(newField)), ['event' num2str(subjectdata.datanr{1,k}) '.xlsx'])
end

event(i).reactiontime = [];


for i = 7:length(event)
    if event(i).value == '33' 
        event(i).reactiontime = event(i).sample - event(i-1).sample;
     end
end

event(i).value ~= '32' || 

