# encoding: UTF-8
# Load sample articles
if ENV['ARTICLES']
  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0008776",
    :title => "The \"Island Rule\" and Deep-Sea Gastropods: Re-Examining the Evidence",
    :published_on => "2010-01-19")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pcbi.1000204",
    :title => "Defrosting the Digital Library: Bibliographic Tools for the Next Generation Web",
    :published_on => "2008-10-31")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0018657",
    :title => "Who Shares? Who Doesn't? Factors Associated with Openly Archiving Raw Research Data",
    :published_on => "2011-07-13")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pcbi.0010057",
    :title => "Ten Simple Rules for Getting Published",
    :published_on => "2005-10-28")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0000443",
    :title => "Order in Spontaneous Behavior",
    :published_on => "2007-05-16")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pbio.1000242",
    :title => "Article-Level Metrics and the Evolution of Scientific Impact",
    :published_on => "2009-11-17")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0035869",
    :title => "Research Blogs and the Discussion of Scholarly Information",
    :published_on => "2012-05-11")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pmed.0020124",
    :title => "Why Most Published Research Findings Are False",
    :published_on => "2005-08-30")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0036240",
    :title => "How Academic Biologists and Physicists View Science Outreach",
    :published_on => "2012-05-09")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0000000",
    :title => "PLoS Journals Sandbox: A Place to Learn and Play",
    :published_on => "2006-12-20")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pmed.0020146",
    :title => "How Prevalent Is Schizophrenia?",
    :published_on => "2005-05-31")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pbio.0030137",
    :title => "Perception Space-The Final Frontier",
    :published_on => "2005-04-12")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pcbi.1002445",
    :title => "Circular Permutation in Proteins",
    :published_on => "2012-03-29")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0036790",
    :title => "New Dromaeosaurids (Dinosauria: Theropoda) from the Lower Cretaceous of Utah, and the Evolution of the Dromaeosaurid Tail",
    :published_on => "2012-05-15")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pbio.0060188",
    :title => "Going, Going, Gone: Is Animal Migration Disappearing",
    :published_on => "2008-07-29")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0001636",
    :title => "Measuring the Meltdown: Drivers of Global Amphibian Extinction and Decline",
    :published_on => "2008-02-20")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0006872",
    :title => "Persistent Exposure to Mycoplasma Induces Malignant Transformation of Human Prostate Cells",
    :published_on => "2009-09-01")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pcbi.0020131",
    :title => "Sampling Realistic Protein Conformations Using Local Structural Bias",
    :published_on => "2006-09-22")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pbio.0040015",
    :title => "Thriving Community of Pathogenic Plant Viruses Found in the Human Gut",
    :published_on => "2005-12-20")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pbio.0020413",
    :title => "Taking Stock of Biodiversity to Stem Its Rapid Decline",
    :published_on => "2004-10-26")

  Article.find_or_create_by_doi(
    :doi => "10.5194/acp-5-1053-2005",
    :title => "Organic aerosol and global climate modelling: a review",
    :published_on => "2005-03-30")

  Article.find_or_create_by_doi(
    :doi => "10.5194/acp-11-9709-2011",
    :title => "Modelling atmospheric OH-reactivity in a boreal forest ecosystem",
    :published_on => "2011-09-20")

  Article.find_or_create_by_doi(
    :doi => "10.5194/acp-11-13325-2011",
    :title => "Comparison of chemical characteristics of 495 biomass burning plumes intercepted by the NASA DC-8 aircraft during the ARCTAS/CARB-2008 field campaign",
    :published_on => "2011-12-22")

  Article.find_or_create_by_doi(
    :doi => "10.5194/acp-12-1-2012",
    :title => "A review of operational, regional-scale, chemical weather forecasting models in Europe",
    :published_on => "2012-01-02")

  Article.find_or_create_by_doi(
    :doi => "10.5194/se-1-1-2010",
    :title => "The Eons of Chaos and Hades",
    :published_on => "2010-02-02")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.ppat.1000446",
    :title => "A New Malaria Agent in African Hominids",
    :published_on => "2009-05-29")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0020094",
    :title => "Meiofauna in the Gollum Channels and the Whittard Canyon, Celtic Margin—How Local Environmental Conditions Shape Nematode Structure and Function",
    :published_on => "2011-05-18")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pbio.0000045",
    :title => "The Genome Sequence of Caenorhabditis briggsae: A Platform for Comparative Genomics",
    :published_on => "2003-11-17")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pbio.0050254",
    :title => "The Diploid Genome Sequence of an Individual Human",
    :published_on => "2007-09-04")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0044271",
    :title => "Lesula: A New Species of <italic>Cercopithecus</italic> Monkey Endemic to the Democratic Republic of Congo and Implications for Conservation of Congo’s Central Basin",
    :published_on => "2012-09-12")

  Article.find_or_create_by_doi(
    :doi => "10.1371/journal.pone.0033288",
    :title => "Genome Features of 'Dark-Fly', a <italic>Drosophila</italic> Line Reared Long-Term in a Dark Environment",
    :published_on => "2012-03-14")

  Article.find_or_create_by_doi(
    :doi => "10.2307/1158830",
    :title => "Histoires de riz, histoires d'igname: le cas de la Moyenne Cote d'Ivoire",
    :published_on => "1981-01-01")

  Article.find_or_create_by_doi(
    :doi => "10.2307/683422",
    :title => "Review of: The Life and Times of Sara Baartman: The Hottentot Venus by Zola Maseko",
    :published_on => "2000-09-01")
end