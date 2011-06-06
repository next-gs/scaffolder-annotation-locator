Feature: Locating annotations on single contig scaffold
  In order to build a genome from multiple contigs
  A user can use scaffold-annotation-locator
  to update annotation coordinates with respect from multiple contigs

  Scenario: Three annotations on three contigs
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
        - sequence:
            source: contig2
        - sequence:
            source: contig3
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      > contig2
      AAAAAGGGGGCCCCCTTTTT
      > contig3
      AAAAAGGGGGCCCCCTTTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	10	.	+	1	ID=gene1
      contig2	.	CDS	1	6	.	+	1	ID=gene2
      contig3	.	CDS	1	6	.	+	1	ID=gene2
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	10	.	+	1	ID=gene1
      scaffold	.	CDS	21	26	.	+	1	ID=gene2
      scaffold	.	CDS	41	46	.	+	1	ID=gene2
      """

  Scenario: Unordered Annotations on multiple contigs
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
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
      contig2	.	CDS	1	6	.	+	1	ID=gene2
      contig1	.	CDS	1	10	.	+	1	ID=gene1
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	10	.	+	1	ID=gene1
      scaffold	.	CDS	21	26	.	+	1	ID=gene2
      """

  Scenario: Annotations on trimmed contigs
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
            stop: 17
        - sequence:
            source: contig2
            start: 4
            stop: 9
        - sequence:
            source: contig3
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      > contig2
      AAAAAGGGGGCCCCCTTTTT
      > contig3
      AAAAAGGGGGCCCCCTTTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	10	.	+	1	ID=gene1
      contig2	.	CDS	4	6	.	+	1	ID=gene2
      contig3	.	CDS	1	6	.	+	1	ID=gene3
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	10	.	+	1	ID=gene1
      scaffold	.	CDS	18	20	.	+	1	ID=gene2
      scaffold	.	CDS	24	29	.	+	1	ID=gene3
      """

  Scenario: Annotations on reversed and trimmed contigs
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
            stop: 17
        - sequence:
            source: contig2
            start: 4
            stop: 9
            reverse: true
        - sequence:
            source: contig3
            reverse: true
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      > contig2
      AAAAAGGGGGCCCCCTTTTT
      > contig3
      AAAAAGGGGGCCCCCTTTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	10	.	+	1	ID=gene1
      contig2	.	CDS	4	6	.	+	1	ID=gene2
      contig3	.	CDS	1	6	.	+	1	ID=gene3
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	10	.	+	1	ID=gene1
      scaffold	.	CDS	21	23	.	-	1	ID=gene2
      scaffold	.	CDS	38	43	.	-	1	ID=gene3
      """

  Scenario: Annotations on two contigs separated by an unannotated contig
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
        - sequence:
            source: contig2
        - sequence:
            source: contig3
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      > contig2
      AAAAAGGGGGCCCCCTTTTT
      > contig3
      AAAAAGGGGGCCCCCTTTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	6	.	+	1	ID=gene1
      contig3	.	CDS	1	6	.	+	1	ID=gene2
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	6	.	+	1	ID=gene1
      scaffold	.	CDS	41	46	.	+	1	ID=gene2
      """

  Scenario: Annotations on a single duplicated contig
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
        - sequence:
            source: contig1
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	6	.	+	1	ID=gene1
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	6	.	+	1	ID=gene1
      scaffold	.	CDS	21	26	.	+	1	ID=gene1
      """

  Scenario: Annotations on reversed and trimmed contigs with inserts
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
            stop: 6
        - sequence:
            source: contig2
            reverse: true
            inserts:
            - 
              source: insert1
              open: 6
              close: 7
        - sequence:
            source: contig3
            start: 3

      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGG
      > contig2
      AAAAAGGGGGC
      > contig3
      AAAAAGGG
      > insert1
      TTT
      """
    Given a file named "anno.gff" with:
      """
      ##gff-version 3
      contig1	.	CDS	1	4	.	+	1	ID=gene1
      contig1	.	CDS	5	8	.	+	1	ID=gene2
      contig2	.	CDS	1	4	.	+	1	ID=gene3
      contig2	.	CDS	8	11	.	+	1	ID=gene4
      contig3	.	CDS	1	3	.	+	1	ID=gene5
      contig3	.	CDS	4	8	.	+	1	ID=gene6
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	4	.	+	1	ID=gene1
      scaffold	.	CDS	15	18	.	-	1	ID=gene3
      scaffold	.	CDS	7	10	.	-	1	ID=gene4
      scaffold	.	CDS	20	24	.	+	1	ID=gene6
      """
