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

  Scenario: Two gene annotation on separate scaffolds
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
      contig1	.	CDS	4	13	.	+	1	ID=gene1
      contig2	.	CDS	4	13	.	+	1	ID=gene2
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff"
    Then the result should be:
      """
      ##gff-version 3
      scaffold	.	CDS	1	10	.	+	1	ID=gene1
      scaffold	.	CDS	24	33	.	+	1	ID=gene2
      """
