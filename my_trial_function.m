function [trl, event] = mytrialfun(cfg);


cfg.trialdef.eventtype  = 'trigger';
cfg.trialdef.prestim    = 0.200; % in seconds

p = [];
if cfg.nr ==1 ||cfg.nr ==2|| cfg.nr ==3 ||cfg.nr ==4
    p = 1.0;
else
    p = 0.7;
end

cfg.trialdef.poststim   = p; % in seconds

% read the header information and the events from the data
hdr   = ft_read_header(cfg.dataset);
event = ft_read_event(cfg.dataset);

% search for "trigger" events
value= {event(:).value}';
sample= {event(:).sample}';

% determine the number of samples before and after the trigger
pretrig  = -round(cfg.trialdef.prestim  * hdr.Fs);
posttrig =  round(cfg.trialdef.poststim * hdr.Fs);


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
            trlbegin = sample{j} + pretrig;       
            trlend   = sample{j} + posttrig;       
            offset   = pretrig;
            newtrl   = [trlbegin trlend offset];
            trl      = [trl; newtrl];
        end
        
         
  elseif cfg.nr ==2
        if str2num(trg1)==11 && str2num(trg2)==33
           trlbegin = sample{j} + pretrig;       
           trlend   = sample{j} + posttrig;       
           offset   = pretrig;
           newtrl   = [trlbegin trlend offset];
           trl      = [trl; newtrl];
        end
        
  elseif cfg.nr ==3;           
        if str2num(trg1)==11 && str2num(trg2)==33
           trlbegin = sample{j} + pretrig;       
           trlend   = sample{j} + posttrig;       
           offset   = pretrig;
           newtrl   = [trlbegin trlend offset];
           trl      = [trl; newtrl];
        end
        
  elseif cfg.nr ==4;    
        if str2num(trg1)==11 && str2num(trg2)==33
           trlbegin = sample{j} + pretrig;       
           trlend   = sample{j} + posttrig;       
           offset   = pretrig;
           newtrl   = [trlbegin trlend offset];
           trl      = [trl; newtrl];
        end
      
   elseif cfg.nr ==5;         
        if str2num(trg1)==21 && str2num(trg2)==33 ||str2num(trg1)==23 && str2num(trg2)==33 ||str2num(trg1)==25 && str2num(trg2)==33 || str2num(trg1)==27 && str2num(trg2)==33
           trlbegin = sample{j} + pretrig;       
           trlend   = sample{j} + posttrig;       
           offset   = pretrig;
           newtrl   = [trlbegin trlend offset];
           trl      = [trl; newtrl];
        end
  elseif cfg.nr == 6;
        if str2num(trg1)==22 && str2num(trg2)==33 ||str2num(trg1)==24 && str2num(trg2)==33 ||str2num(trg1)==26 && str2num(trg2)==33 || str2num(trg1)==28 && str2num(trg2)==33           
            trlbegin = sample{j} + pretrig;       
           trlend   = sample{j} + posttrig;       
           offset   = pretrig;
           newtrl   = [trlbegin trlend offset];
           trl      = [trl; newtrl];
         end
    end; 
end;