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

process TRIMADAPTERS {
    conda 'dependencies/dev.yml'

    input:
       val sample

    output:
        tuple val(sample.name), path("*_trimmed_{1,2}.fq"), emit: trimmed_fastqs
        path("*_cutadapt.log"), emit: cutadapt_log

    script:
        """
        cutadapt -j 20 \
        --times 1  -e 0.1  -O 3 \
        --quality-cutoff 25 -m 55 -a AGATCGGAAGAGCACACGT \
        -A  AGATCGGAAGAGCGTCGTG -o ${sample.name}_trimmed_1.fq \
        -p ${sample.name}_trimmed_2.fq ${sample.r1} ${sample.r2} > ${sample.name}_cutadapt.log
        """
 }

workflow {
    // Collect sample data and metadata
    ch_samples = Channel.fromList(samplesheetToList(params.input, "schemas/input_schema.json"))
    .map { sample_meta ->
        new SampleMetadata(
            name: sample_meta[0],
            r1: file(sample_meta[1]),
            r2: file(sample_meta[2])
        )
    }
    TRIMADAPTERS(ch_samples)
}