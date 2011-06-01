Feature: Parsing contigs with inserts
  In order to include inserts in a scaffold
  A user can use scaffold-annotation-locator
  to update annotation coordinates with respect to contigs with inserts

  Scenario: An annotation before an insert in a contig
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
            inserts:
            -
              source: insert1
              open: 14
              close: 15
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      > insert1
      TTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	4	13	.	+	1	ID=gene1
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	4	13	.	+	1	ID=gene1
      """

  Scenario: An annotation after an insert in a contig
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
            inserts:
            -
              source: insert1
              open: 1
              close: 3
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      > insert1
      TTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	4	13	.	+	1	ID=gene1
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	5	14	.	+	1	ID=gene1
      """
