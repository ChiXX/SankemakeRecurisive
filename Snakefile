def get_input_features(wc):

    previous_run = int(wc['run_n']) - 1
    return f'test/features_{previous_run}.txt'


def check_if_final_features(wc):
    r"""
    function for both recursion and as input function
    """
    MAX_RUNS = 10

    # initial run is 1
    if 'run_n' not in wc:
        wc = {'test': wc[0],
              'run_n': 1}

    # checks output of each checkpoint and if condition is not met
    # creates anothe checkpoint with incement run number
    print(wc)
    with checkpoints.select_features.get(**wc).output[0].open() as f:
        # performance metrics check = exit from recursion
        if len(f.readlines()) <= 2 or wc['run_n'] == MAX_RUNS:
            return '{test}/features_{run_n}.txt'.format(**wc)
        else:
            wc['run_n'] += 1
            return check_if_final_features(wc)

    
rule final_features_report:
    r"""
    Produces list of final features
    """
    input:
        check_if_final_features
    output:
        '{test}/final_features.txt'
    shell:
        "cat {input} > {output}"

checkpoint select_features:
    r"""
    One run to select features, here just removes two first rows.
    """
    input:
        get_input_features
    output:
        '{test}/features_{run_n}.txt'
    shell:
        "cat {input} | tail -n +2 > {output}"
