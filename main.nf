include {
    validateParameters;
    paramsHelp;
    paramsSummaryLog;
    samplesheetToList;
} from 'plugin/nf-schema'

// Print help message, supply typical command line usage for the pipeline
if (params.help) {
    log.info paramsHelp("nextflow run my_pipeline --input input_file.csv")
    exit 0
}

// Validate input parameters
validateParameters()

// Print summary of supplied parameters
log.info paramsSummaryLog(workflow)

process HELLOWORLD {

    input:
       val sample

    output:
        stdout emit: output_stdout
        path 'output.txt', emit: output_file

    script:
        """
        echo ${sample}
        echo ${sample} > output.txt
        """
 }

workflow {
    ch_samples = Channel.fromList(samplesheetToList(params.input, "schemas/input_schema.json"))
    ch = HELLOWORLD(ch_samples)
}