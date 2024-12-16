# Awareness of the future: Dolphins know when they need to remember for the future

The R code and data needed to replicate results from the article:

```
Awareness of the future: Dolphins know when they need to remember for the future
```

------------------------------------------------

**Abstract**

In humans, awareness of an upcoming memory test enhances intentional encoding and improves memory recall. Here, we investigated whether dolphins exhibit similar future-oriented encoding of information known to be needed in the future. Dolphins were trained to remember specific, randomly assigned actions for later re-enactment, with either immediate or delayed recall. When an unexpected delay was introduced in trials anticipating immediate recall, memory was retained for only 13 seconds, suggesting working memory encoding. However, when instructed to expect delayed recall, dolphins accurately reproduced actions after delays even after 16 hours. These results suggest that dolphins, anticipating future need, intentionally encode actions to be performed in the future into long-term memory, implying prospective encoding and prospective memory capacities. Their memory also displayed key features of episodic memory: encoding occurred in a single episode, and memory was declarative, as the action itself declared its content. Moreover, dolphins more effectively recalled self-performed actions compared to gestural codifications of the same actions, mirroring the human-typical enactment effect and supporting episodic-like memory over semantic memory. Our findings indicate that dolphins show awareness of future memory demands and seem to use a future-oriented, episodic-like memory system, capable of storing prospectively encoded, intended actions in long-term memory.

------------------------------------------------

NOTE: Some large model files are not available in this repository. They can be downloaded from Dryad after publication. That repository also contains all code, so replicating results is easier from there.

------------------------------------------------

**File information and meta data:**

- `.gitignore`: tells git which files should not be synchronised
- `LICENSE`: file with license details
- `README.md`: the file you are reading right now
- `dolphin_memory_new.Rproj`: R project file, if you open this all paths will work for this repo
- `statistical_analysis.Rmd`: R markdown document with all LaTeX code for the models
- `statistical_analysis.docx`: Word version of the models
- `statistical_analysis.pdf`: PDF version of the models

- `analysis/code/00_prospective_delay_load_data.R`: script to load the data for the trials testing prospective memory including delays
- `analysis/code/01_prospective_delay_run_model.R`: script to run the models for the trials testing prospective memory including delays
- `analysis/code/02_prospective_control_load_data.R`: script to load the data for control the trials, where dolphins had not been trained to expect a delay
- `analysis/code/03_prospective_control_run_models.R`: script to run the models for control the trials, where dolphins had not been trained to expect a delay
- `analysis/code/04_retrospective_no_delay_load_data.R`: script to load the data for the trials testing retrospective memory, without delays
- `analysis/code/05_retrospective_no_delay_run_model.R`: script to run the models for the trials testing retrospective memory, without delays
- `analysis/code/06_retrospective_delay_load_data.R`: script to load the data for the trials testing retrospective memory, with delays
- `analysis/code/07_retrospective_delay_run_model.R`: script to run the models for the trials testing retrospective memory, with delays
- `analysis/code/08_enactment_effect_load_data.R`: script to load the data for the trials testing the enactment effect
- `analysis/code/09_enactment_effect_run_model.R`: script to run the model for the trials testing the enactment effect
- `analysis/code/10_plot_figure_1.R`: script to plot figure 1 from the main text
- `analysis/code/11_plot_figure_2.R`: script to plot figure 2 from the main text
- `analysis/code/12_plot_figure_3.R`: script to plot figure 3 from the main text

- `analysis/data/data_enactment_effect_with_action.csv`: data for the trials testing the enactment effect, where dolphins performed the action
  - `Animal`: the name of the test animal (Achille, Ulisse)
  - `Phase`: the phase of the experiment (1, 2)
  - `Trial`: the trial number within session (1-20)
  - `Behaviour marked`: the name of the behaviour the animal should perform (Belly up, Tail wave, Spin, Clap)
  - `Date`: date for the session (dd/mm/yyyy, empty for phase 1)
  - `Time marking`: time when the behaviour was marked (emtpy)
  - `Time recall`: time when the behaviour was performed (emtpy)
  - `Total time`: the total time of the delay (empty)
  - `Behaviour offered`: the behaviour performed by the animal (Belly up, Tail wave, Spin, Clap, Pectoral)
  - `Double blind`: always 0 or empty, these trials were not double blind
  - `Distractions`: empty
- `analysis/data/data_enactment_effect_without_action.csv`: data for the trials testing the enactment effect, where dolphins did not perform the action
  - `Animal`: the name of the test animal (Achille, Ulisse)
  - `Phase`: the phase of the experiment (1, 2)
  - `Trial`: the trial number within session (1-8)
  - `Behaviour marked`: the name of the behaviour the animal should perform (Belly up, Tail wave, Spin, Clap)
  - `Date`: empty
  - `Time marking`: empty
  - `Time recall`: empty
  - `Total time`: the total time of the delay in seconds (10, 60)
  - `Behaviour offered`: the behaviour performed by the animal (Belly up, Tail wave, Spin, Clap, Sing)
  - `Double blind`: always 0, these trials were not double blind
  - `Distractions`: empty
- `analysis/data/data_prospective_control.csv`: data for control the trials, where dolphins had not been trained to expect a delay
  - `Animal`: the name of the test animal (Achille, Ulisse, Ilse)
  - `Phase`: the phase of the experiment (0, 3)
  - `Trial`: the trial number within session (1-20)
  - `Behaviour marked`: the name of the behaviour the animal should perform (Belly up, Tail wave, Spin, Clap)
  - `Date`: date for the session (dd/mm/yyyy)
  - `Time marking`: time when the behaviour was marked (hh:mm, empty for phase 0)
  - `Time recall`: time when the behaviour was performed (hh:mm, empty for phase 0)
  - `Total time`: the total time of the delay (seconds, empty for phase 0)
  - `Behaviour offered`: the behaviour performed by the animal (Belly up, Tail wave, Spin, Clap, Pectoral)
  - `Double blind`: always 0 or empty, these trials were not double blind
  - `Distractions`: empty
  - `Trainer mark`: the trainer marking the behaviour to be remembered, character ('', Abby, Abril, Andrea, Benja, Carlos, Emma, Gris, Hector, Jenny, Jhonny, Jorge, Juan Carlos, Nayeli, Rafa, Tania, Vero)
  - `Trainer recall`: the trainer marking the behaviour to be remembered, character ('', Abby, Abril, Alan, Andrea, Benja, Carlos, Ceci, Emma, Gris, Hector, Jenny, Jhonny, Jorge, Juan Carlos, Nayeli, Rafa, Richie, Tania, Tavo, Vero) 
- `analysis/data/data_prospective_delay.csv`: data for the trials testing prospective memory including delays
  - `Animal`: the name of the test animal (Eva, Karina, Lluvia, Nouba, Nemo)
  - `Phase`: the phase of the experiment (0-7)
  - `Trial`: the trial number within session (1-18)
  - `Behaviour marked`: the name of the behaviour the animal should perform (Clap, Go down, Jump, Sing, Spin, Splash, Tail wave)
  - `Date`: date for the session (dd/mm/yyyy)
  - `Time marking`: time when the behaviour was marked (hh:mm, empty for phase 0)
  - `Time recall`: time when the behaviour was performed (hh:mm, empty for phase 0)
  - `Total time`: the total time of the delay (seconds, empty for phase 0)
  - `Behaviour offered`: the behaviour performed by the animal (Clap, Fart, Go down, Jump, Sing, Spin, Splash, Tail wave)
  - `Double blind`: always 0 or empty, these trials were not double blind
  - `Distractions`: empty
- `analysis/data/data_retrospective_delay.csv`: data for the trials testing retrospective memory, with delays
  - `Animal`: the name of the test animal (Achille, Clara, Ulisse)
  - `Session`: the session number (1-12)
  - `correct.or.not.1`: whether or not the first behaviour was correct (c = correct, n = not correct)
  - `correct.or.not.2`: whether or not the second behaviour was correct (c = correct, n = not correct)
  - `delay`: the duration of the delay between the first and second behaviour (3, 6, 9, 12, 18, 21)
  - `b1`: the first behaviour asked by the trainer (aplauso, belly_up, canto, giro)
  - `b2`: the second behaviour asked by the trainer (aplauso, belly_up, canto, giro, repeat) 
- `analysis/data/data_retrospective_no_delay.csv`: data for the trials testing retrospective memory, without delays (note that three behaviours were performed, so that the last two could be repeats to create a double repeat, this is not clear from the csv, but is fixed when the data is loaded in `06_retrospective_delay_load_data.R`
  - `Animal`: the name of the test animal (Achille, Clara, Ulisse)
  - `Session`: the session number (1-8)
  - `Behaviour_1`: the first behaviour asked by the trainer (belly_up, clap, repeat, sing, spin)
  - `Offered_1`: the first behaviour offered by the dolphin (belly_up, clap, not_ask, sing, spin)
  - `Behaviour_2`: the second behaviour asked by the trainer (belly_up, clap, repeat, sing, spin)
  - `Offered_2`: the second behaviour offered by the dolphin (belly_up, clap, not_ask, sing, spin)
    
-  `analysis/results`: contains the figures (.pdf) and model outputs (.RData) from all R scripts

    
NOTE: each code file contains a short description. 
NOTE: some csv files contain typo's, these are fixed in the scripts that load them and only the corrected values are included in the meta data.

------------------------------------------------

**Maintainers and contact:**

Please contact Simeon Q. Smeele, <simeonqs@hotmail.com>, if you have any questions or suggestions. 




