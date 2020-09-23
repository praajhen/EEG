
subjectdata.subjectdir        = 'M:\Projects\eSeek\Study3_EEG\data\PRE_Processing\ANT';
subjectdata.datadir         =  {'ID_102_RAW.set','ID_103_RAW.set','ID_105_RAW.set','ID_108_RAW.set','ID_113_RAW.set','ID_114_RAW.set','ID_119_RAW.set','ID_123_RAW.set','ID_126_RAW.set','ID_130_RAW.set','ID_132_RAW.set','ID_142_RAW.set','ID_144_RAW.set','ID_147_RAW.set','ID_151_RAW.set','ID_152_RAW.set','ID_157_RAW.set','ID_160_RAW.set','ID_161_RAW.set','ID_162_RAW.set','ID_164_RAW.set','ID_166_RAW.set','ID_167_RAW.set','ID_174_RAW.set','ID_179_RAW.set','ID_181_RAW.set','ID_185_RAW.set','ID_186_RAW.set','ID_188_RAW.set','ID_190_RAW.set','ID_197_RAW.set','ID_198_RAW.set','ID_202_RAW.set','ID_206_RAW.set','ID_214_RAW.set','ID_216_RAW.set','ID_218_RAW.set','ID_219_RAW.set','ID_225_RAW.set','ID_233_RAW.set','ID_236_RAW.set','ID_251_RAW.set','ID_258_RAW.set','ID_265_RAW.set','ID_270_RAW.set','ID_271_RAW.set','ID_274_RAW.set','ID_276_RAW.set','ID_279_RAW.set','ID_283_RAW.set','ID_286_RAW.set','ID_288_RAW.set','ID_296_RAW.set','ID_297_RAW.set','ID_298_RAW.set','ID_305_RAW.set','ID_312_RAW.set','ID_322_RAW.set','ID_323_RAW.set','ID_326_RAW.set','ID_332_RAW.set','ID_340_RAW.set','ID_350_RAW.set','ID_352_RAW.set','ID_353_RAW.set','ID_354_RAW.set','ID_356_RAW.set','ID_365_RAW.set','ID_369_RAW.set','ID_374_RAW.set','ID_380_RAW.set','ID_393_RAW.set','ID_394_RAW.set','ID_399_RAW.set','ID_407_RAW.set','ID_418_RAW.set','ID_419_RAW.set','ID_423_RAW.set','ID_425_RAW.set','ID_429_RAW.set','ID_433_RAW.set','ID_440_RAW.set','ID_444_RAW.set','ID_447_RAW.set','ID_458_RAW.set','ID_459_RAW.set','ID_461_RAW.set','ID_462_RAW.set','ID_465_RAW.set','ID_481_RAW.set','ID_492_RAW.set','ID_502_RAW.set','ID_505_RAW.set','ID_508_RAW.set','ID_531_RAW.set','ID_537_RAW.set'};
subjectdata.datanr = {'102','103','105','108','113','114','119','123','126','130','132','142','144','147','151','152','157','160','161','162','164','166','167','174','179','181','185','186','188','190','197','198','202','206','214','216','218','219','225','233','236','251','258','265','270','271','274','276','279','283','286','288','296','297','298','305','312','322','323','326','332','340','350','352','353','354','356','365','369','374','380','393','394','399','407','418','419','423','425','429','433','440','444','447','458','459','461','462','465','481','492','502','505','508','531','537'};
subjectdata.conditions = {'11', '12', '13','14', {'21' '23' '25' '27'}, {'22' '24' '26' '28'} };

%Interpolated subjects
subjectdata.datadir =  {'ID_105_RAW.set','ID_132_RAW.set','ID_144_RAW.set','ID_225_RAW.set','ID_274_RAW.set','ID_305_RAW.set','ID_423_RAW.set','ID_429_RAW.set'};
subjectdata.datanr  = {'105','132','144','225','274','305','423','429'};
  



%Read the EEG data and eye tracking  (only correct responses, ROI)

for  k = 1:length(subjectdata.datanr);
    
    for  c = 1:length(subjectdata.conditions);
        cfg = [];
        cfg.dataset  = [subjectdata.subjectdir filesep subjectdata.datadir{1,k}];
        cfg.nr = c;
        cfg.trialfun            = 'mytrialfun'; % this is the default
        cfg.trialdef.eventtype  = 'trigger';
        cfg.trialdef.eventvalue = [subjectdata.conditions{1,c}];
        cfg.trialdef.prestim    = 0.2;
        % 	cfg.trialdef.poststim   = 1.0;
        cfg                     = ft_definetrial(cfg);
        data_org = ft_preprocessing(cfg);
        
        
        
        % Read  only EEG raw data and apply HP filter
        
        cfg = [];
        cfg.dataset  = [subjectdata.subjectdir filesep subjectdata.datadir{1,k}];
        cfg.hpfilter = 'yes';
        cfg.hpfreq = 0.5;
        cfg.hpfiltord= 5;
        cfg.channel = 'EEG';
        data_org_eeg_hp = ft_preprocessing(cfg);
        
        % Segment the HP filtered raw EEG data and apply low pass filter
        cfg                     = [];
        cfg.dataset             = [subjectdata.subjectdir filesep subjectdata.datadir{1,k}];
        cfg.nr = c;
        cfg.trialfun            = 'mytrialfun'; % this is the default
        cfg.trialdef.eventtype  = 'trigger';
        cfg.trialdef.eventvalue = [subjectdata.conditions{1,c}];
        cfg.trialdef.prestim    = 0.2;
        cfg.lpfilter = 'yes';
        cfg.lpfreq= 30;
        cfg.demean = 'yes';
        cfg.baselinewindow = [-0.2 0];
        cfg                     = ft_definetrial(cfg);
        
        data = ft_redefinetrial(cfg,data_org_eeg_hp);
        
        data1 = ft_preprocessing(cfg,data);
        
        xyz = [];
        if c == 1 ;
            xyz = 'nc';
        elseif c == 2;
            xyz = 'cc';
        elseif c == 3;
            xyz = 'dc';
        elseif c == 4;
            xyz = 'sc';
        elseif c == 5;
            xyz = 'con';
        elseif c == 6;
            xyz = 'incon';
        end
        
        %==============================================================================================================================================%
        % Eyeblink corrections: reject the trials in which eyetracking data is out
        % of specific range
        %==============================================================================================================================================%
        
        
        ii=1;
        i=1;
        for tr=1:length(data1.trial)
            
            if (min(data_org.trial{1,tr}(130,150:end)) >(440))  &&  (max(data_org.trial{1,tr}(130,150:end)) < (640)) && (min(data_org.trial{1,tr}(133,150:end)) >(440))  &&  (max(data_org.trial{1,tr}(133,150:end)) < (640)) &&  (min(data_org.trial{1,tr}(129,150:end)) >(860))  &&  (max(data_org.trial{1,tr}(129,150:end)) < (1060)) && (min(data_org.trial{1,tr}(132,150:end)) >(860))  &&  (max(data_org.trial{1,tr}(132,150:end)) < (1060))
                
                cleantrial{1,ii}(:,:) = data1.trial{1,tr}(1:128,:);
                cleantime{1,ii}(:,:) = data1.time{1,tr}(:,:);
                label{1,ii}(:,:) = tr;
                ii=ii+1;
            else
                badtrial{1,i}(:,:) = data1.trial{1,tr}(1:128,:);
                badtime{1,i}(:,:) = data1.time{1,tr}(:,:);
                postion{1,i} =tr;      %position of position trials
                i=i+1;
            end
            
        end;
       
        if length(cleantrial) == length(data1.trial)
            badtrial = [];
            
        end
        
        if length(badtrial) ==length(data1.trial)
            
            subject{k}.(['ID' num2str(c)])              = subjectdata.datanr{1,k};
            subject{k}.(['condition' num2str(c)])       = xyz;
            subject{k}.(['prestim' num2str(c)])         = data1.cfg.trialdef.prestim;
            subject{k}.(['hp' num2str(c)])	= data_org_eeg_hp.cfg.hpfreq;
            subject{k}.(['correcttrial' num2str(c)])	= length(data1.trial);
            subject{k}.(['badtrial' num2str(c)])         = length(badtrial);
            subject{k}.(['baddifftrial' num2str(c)])     = 'NA';
            subject{k}.(['cleandifftrial' num2str(c)])	= 'not suitable for this pipeline';
     
            continue
        end
        
       
        
        
        %==============================================================================================================================================%
        % Difference between max and min of the signal AND differeniate good and
        % bad channels
        %==============================================================================================================================================%
        
        for tr = 1:length(cleantrial)
            for ch =1:128
                
                difftrial{1,tr}(ch,1)=  max(cleantrial{1,tr}(ch,150:end)) - min(cleantrial{1,tr}(ch,150:end));
                
            end
        end
        %%
        
        for tr = 1:length(cleantrial)
            for ch =1:128
                
                if difftrial{1,tr}(ch,1)<=175
                    btrial{1,tr}(ch,1)=1;
                else
                    btrial{1,tr}(ch,1)=0;
                    
                end
            end
        end
        
        
        binary =[];
        for tr = 1:length(cleantrial)
            binary = [binary, btrial{1,tr}];
        end
        
        
        
        
        outputdir = 'C:\MyTemp\Project updates\Next update\binarychecktrials';
        xlswrite([outputdir filesep subjectdata.datanr{1,k} '_' xyz ],binary);
        
       
        %%
        
        
        %==============================================================================================================================================%
        % If the difference between max and min is above the threshold then take
        % the trials to cleandifftrial else to baddifftrials
        %==============================================================================================================================================%
        
        ii=1;
        i=1;
        
        for tr = 1:length(cleantrial);
            if max(difftrial{1,tr}(1:128,1))<175 %threshold value
                
                cleandifftrial{1,ii}(:,:) = cleantrial{1,tr}(1:128,:);
                cleandifftime{1,ii}(:,:) = cleantime{1,tr}(:,:);
                l(ii) = label(tr);
                ii=ii+1;
            else
                baddifftrial{1,i}(:,:) = cleantrial{1,tr}(1:128,:);
                baddifftime{1,i}(:,:) = cleantime{1,tr}(:,:);
                postion{1,i} =tr;      %position of position trials
                i=i+1;
            end
            
        end
        
        
        try
            if length(cleantrial) == length(baddifftrial)
                cleandifftrial = [];
            end
        catch
            if length(cleandifftrial) == length(cleantrial)
                baddifftrial = [];
            end
        end
        
        %==============================================================================================================================================%
        % Reaction time of accepted trials
        %==============================================================================================================================================%
        
        hdr   = ft_read_header(cfg.dataset);
        event = ft_read_event(cfg.dataset);
        
        value= {event(:).value}';
        sample= {event(:).sample}';
        
        
        f = [];
        if cfg.nr ==1 ||cfg.nr ==2|| cfg.nr ==3 ||cfg.nr ==4
            f = 2;
        else
            f = 1;
        end
        trl = [];
        for j = 1:(length(value)- f)
            trg1 = value{j};
            trg2 = value{j+f};
            
            if cfg.nr ==1
                if str2num(trg1)==11 && str2num(trg2)==33
                    trlbegin = sample{j+2} - sample{j+1};
                    newtrl   = [trlbegin];
                    trl      = [trl; newtrl];
                end
                
                
            elseif cfg.nr ==2
                if str2num(trg1)==12 && str2num(trg2)==33
                    trlbegin = sample{j+2} - sample{j+1};
                    newtrl   = [trlbegin];
                    trl      = [trl; newtrl];
                end
                
            elseif cfg.nr ==3;
                if str2num(trg1)==13 && str2num(trg2)==33
                    trlbegin = sample{j+2} - sample{j+1};
                    newtrl   = [trlbegin];
                    trl      = [trl; newtrl];
                end
                
            elseif cfg.nr ==4;
                if str2num(trg1)==14 && str2num(trg2)==33
                    trlbegin = sample{j+2} - sample{j+1};
                    newtrl   = [trlbegin];
                    trl      = [trl; newtrl];
                end
                
            elseif cfg.nr ==5;
                if str2num(trg1)==21 && str2num(trg2)==33 ||str2num(trg1)==23 && str2num(trg2)==33 ||str2num(trg1)==25 && str2num(trg2)==33 || str2num(trg1)==27 && str2num(trg2)==33
                    trlbegin = sample{j+1} - sample{j};
                    newtrl   = [trlbegin];
                    trl      = [trl; newtrl];
                end
            elseif cfg.nr == 6;
                if str2num(trg1)==22 && str2num(trg2)==33 ||str2num(trg1)==24 && str2num(trg2)==33 ||str2num(trg1)==26 && str2num(trg2)==33 || str2num(trg1)==28 && str2num(trg2)==33
                    trlbegin = sample{j+1} - sample{j};
                    newtrl   = [trlbegin];
                    trl      = [trl; newtrl];
                end
            end
        end
        
        
        
        for i = 1: length(l)
            reactiontime(i) = trl(l{1,i});
        end
        
        for i = 1: length(l)
            reactiontime(2,i) = cell2mat(l(i));
        end
        
        
        %==============================================================================================================================================%
        % Copying the artifact free data to editdata1
        %==============================================================================================================================================%
        
        
        if length(baddifftrial) == length(cleantrial)
            %         editdata1.trial = [];
            %         editdata1.time = [];
            
            
            subject{k}.(['ID' num2str(c)])              = subjectdata.datanr{1,k};
            subject{k}.(['condition' num2str(c)])       = xyz;
            subject{k}.(['prestim' num2str(c)])         = data1.cfg.trialdef.prestim;
            %       subject{k}.detail{c,4}	= data1.cfg.trialdef.poststim;
            subject{k}.(['hp' num2str(c)])	= data_org_eeg_hp.cfg.hpfreq;
            subject{k}.(['correcttrial' num2str(c)])	= length(data1.trial);
            subject{k}.(['badtrial' num2str(c)])         = length(badtrial);
            subject{k}.(['baddifftrial' num2str(c)])     = length(baddifftrial);
            subject{k}.(['cleandifftrial' num2str(c)])	= 'not suitable for this pipeline';
            
        else
            editdata = data1;
            editdata.trial = cleandifftrial;
            editdata.time = cleandifftime;
            
            %==============================================================================================================================================%
            % Averaging and noise-covariance estimation
            %==============================================================================================================================================%
            
            cfg =[];
            cfg.covariance = 'yes';
            % cfg.vartrllength = 2;
            % cfg.keeptrials = 'yes';
            timelock = ft_timelockanalysis(cfg,editdata);
            
            outputdir = 'C:\MyTemp\Project updates\next update\Timelock';
            
            
            newField =  ['avg' num2str(subjectdata.datanr{k}) xyz ];
            [t.(newField)]= timelock;
            save([ outputdir filesep num2str(subjectdata.datanr{k}) xyz 'timelock'] ,'-struct','t',  ['avg' num2str(subjectdata.datanr{k}) xyz] ) ;
            
            
            matrix = double(timelock.avg);
            save([outputdir filesep subjectdata.datanr{1,k} xyz 'timelock.txt'  ],'matrix', '-ascii');
            
            outputdir1 = 'C:\MyTemp\Project updates\next update\reactiontime';
            xlswrite([outputdir1 filesep subjectdata.datanr{1,k} xyz 'reactiontime'  ],reactiontime);
            
            subject{k}.(['ID' num2str(c)])              = subjectdata.datanr{1,k};
            subject{k}.(['condition' num2str(c)])       = xyz;
            subject{k}.(['prestim' num2str(c)])         = data1.cfg.trialdef.prestim;
            % 	subject{k}.(['poststim' num2str(c)])        = data1.cfg.trialdef.poststim;
            subject{k}.(['hp' num2str(c)])               = data_org_eeg_hp.cfg.hpfreq;
            subject{k}.(['correcttrial' num2str(c)])     = length(data1.trial);
            subject{k}.(['badtrial' num2str(c)])         = length(badtrial);
            subject{k}.(['baddifftrial' num2str(c)])     = length(baddifftrial);
            subject{k}.(['cleandifftrial' num2str(c)])	= length(cleandifftrial);
            
            
            clearvars -except subject subjectdata k c  result
            
            
        end;
    end
end


result = [];
for s =  1: length(subject);
    
    result = [result, subject{1,s}]
end

%xlswrite('result_1092016',result)

