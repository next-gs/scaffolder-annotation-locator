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
    Given a file named "anno.gff3" with:
      """
      #gff-version 3
      contig1	.	CDS	4	13	.	+	1	ID=gene1
      """
    When I relocate the annotations using "scaf.yml", "seq.fna" and "anno.gff3"
    Then the output should contain:
      """
      #gff-version 3
      scaffold	.	CDS	4	13	.	+	1	ID=gene1
      """
