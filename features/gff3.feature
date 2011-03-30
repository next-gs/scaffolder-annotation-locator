Feature: Locating gff3 annotations on a scaffold
  In order to add gff3 annotations to a scaffold
  A user can use scaffold-annotation-locator
  to return the updated coordinates of scaffold annotations

  Scenario: A single gene annotation on a single contig scaffold
    Given a file named "scaf.yml" with:
      """
      ---
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
      contig1	.	CDS	4	13	.	+	1	ID=gene1
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	4	13	.	+	1	ID=gene1
      """

  Scenario: A gene annotation on a trimmed single contig scaffold
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
            start: 4
      """
    Given a file named "seq.fna" with:
      """
      > contig1
      AAAAAGGGGGCCCCCTTTTT
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
      scaffold	.	CDS	1	10	.	+	1	ID=gene1
      """

  Scenario: A gene annotation on a single reversed contig scaffold
    Given a file named "scaf.yml" with:
      """
      ---
        - sequence:
            source: contig1
            reverse: true
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
      scaffold	.	CDS	15	20	.	-	1	ID=gene1
      """

  Scenario: Multiple gene annotations on separate contigs
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

  Scenario: Multiple gene annotations on trimmed scaffolds
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

  Scenario: Multiple gene annotations on reverse and trimmed contigs
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

