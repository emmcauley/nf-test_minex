import java.nio.file.Path
import groovy.transform.Immutable
import nextflow.io.ValueObject
import nextflow.util.KryoHelper

/* Container class for sample-specific metadata */
@ValueObject
@Immutable(copyWith=true, knownImmutables = ['r1', 'r2'])
class SampleMetadata {
    /** The sample name */
    String name
    /** The path to the read one FASTQ */
    Path r1
    /** The path to the read two FASTQ */
    Path r2

    static {
    // Register this class with the Kryo framework that serializes and deserializes objects
    // that pass through channels. This allows for caching when this object is used.
    KryoHelper.register(SampleMetadata)
  }

}