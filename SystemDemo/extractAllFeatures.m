clear all;

addpath('/Users/Sam/Dropbox/Uni/EN2202/PattRecClasses');
addpath('/Users/Sam/Dropbox/Uni/EN2202/GetSpeechFeatures');

directories = {'Fridge', 'Microwave', 'Oven', 'Phone', 'Television', 'TurnOff', 'TurnOn'};
states = [5 7 5 5 7 6 6];
num_words = length(directories);
words = {};

recordingDir = '/Users/Sam/Dropbox/Uni/EN2202/Recordings/';
testSamples = 15;


window = 0.030;
bands = 13;

features = {};


for word_i = 1:num_words
    
    word_features = [];
    sample_lengths = zeros(num_words, 1);
    
    for sample_i = 1:testSamples
        %read the audio
        [sample,fs,nbits] = wavread(strcat(recordingDir, directories{word_i}, '/', int2str(sample_i), '.wav'));
        %words{word_i, sample_i} = sample;
        
        mfccs=getNormalisedFeatures(sample, fs, window, bands);
        word_features = [word_features mfccs];
        sample_lengths(sample_i) = size(mfccs, 2);
    end
    
    hmms(word_i) = MakeLeftRightHMM(states(word_i), GaussMixD(), word_features, sample_lengths');
end

save('vari_states_15trained', 'hmms');


%read in each audio sample

%get the features and normalise

%put them in long vectors but remember how long each sample is