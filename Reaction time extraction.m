subjectdata.subjectdir        = 'directory';
subjectdata.datadir         =  {'file1.set','file2.set'}; % data
subjectdata.datanr = {'file1','file2'}; % file_name
subjectdata.conditions = {'11', '12', '13','14', {'21' '23' '25' '27'}, {'22' '24' '26' '28'} }; %triggers


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

