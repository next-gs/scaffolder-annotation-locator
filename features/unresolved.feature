Feature: Parsing unresolved regions
  In order to include unresolved regions in a scaffold
  A user can use scaffold-annotation-locator
  to update annotation coordinates with respect to unresolved regions

  Scenario: Annotations on two contigs separated by an unresolved region
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
        - unresolved:
            length: 10
        - sequence:
            source: contig2
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      > contig2
      AAAAAGGGGGCCCCCTTTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	6	.	+	1	ID=gene1
      contig2	.	CDS	1	6	.	+	1	ID=gene2
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	6	.	+	1	ID=gene1
      scaffold	.	CDS	31	36	.	+	1	ID=gene2
      """

