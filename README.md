As the U.S. government's official web portal, [USA.gov](http://www.usa.gov) and its Spanish counterpart [GobiernoUSA.gov](http://www.usa.gov/gobiernousa/) search across all federal, state, local, tribal, and territorial government websites. Most government websites end in .gov or .mil, but many end in .com, .org, .edu, or other top-level domains.

This is a list of government URLs that don't end in .gov or .mil.

# What's included in this list?

* Federal, state, local, [tribal](http://www.usa.gov/Government/Tribal-Sites/index.shtml), commonwealth, and territorial government agency websites
* [Federal reserve banks and branches](http://www.federalreserve.gov/otherfrb.htm)
* [Federal home loan banks](http://www.fhlbanks.com/contacts_mpi_atlanta.htm)
* Libraries, archives, and museums, including [Presidential libraries](http://www.archives.gov/presidential-libraries/)
* Department of Defense websites for [recruiting](http://www.defense.gov/RegisteredSites/RegisteredSites.aspx?s=R) and [service academies](http://www.defense.gov/RegisteredSites/RegisteredSites.aspx?s=A)
* [Travel and tourism](http://www.usa.gov/Citizen/Topics/Travel-Tourism/State-Tourism.shtml) websites for states and U.S. territories
* [State lotteries](http://www.usa.gov/Topics/Lottery-Results.shtml)
* [Cooperative extensions](http://www.csrees.usda.gov/Extension/USA-text.html)
* [Combined federal campaigns](http://www.opm.gov/combined-federal-campaign/find-local-campaigns/locator/)
* [Government sponsored enterprises](http://assets.opencrs.com/rpts/RS21663_20080909.pdf) (such as Fannie Mae) [PDF]
* Federal and state retirement systems
* Task forces (such as the Preventative Services Task Force) and commissions (such as the 9/11 Commission)
* A few select, nongoverment organizations (such as the Red Cross) and public-private partnerships

# What's not included in this list?

* .gov URLs
* .mil URLs
* Subdomains or folders that are already covered by a higher-level domain
* State institutions of higher education or their board of regents
* K-12 school districts
* Local fire, library, police, sheriff, etc. departments with separate websites
* Local chambers of commerce or visitor bureaus
* Nonprofit municipal leagues or councils of government officials
* Nonprofit historical societies
* Transit authorities

# How is this list organized?

We maintain this list at <http://govt-urls.usa.gov/tematres/vocab/index.php> and make periodic updates as we come across changes.

Each quarter, we also post the URLs here in Github in three files.

1. [Alphabetic](/government-urls-alphabetic-list.txt)&mdash;an A-Z list of URLs with accompanying notes and relationships collected over time.
2. [Hierarchical](/government-urls-hierarchical-list.txt)&mdash;a flat list of URLs segmented by category (see BT description in the following section).
3. [YAML](/government-urls.yaml)&mdash;a mapping file of the URLs for applications. (Also in [JSON](http://gsa.github.io/govt-urls/government_urls.json))


Cross reference symbols that you'll find in the alphabetic list include:

* **BT (broader term)**&mdash;indicates the category for each URL, such as federal (usagovFED) or state, commonwealth, or territory (usagov__, 2-letter [postal abbreviation](https://www.usps.com/send/official-abbreviations.htm)).
* **NT (narrower term)**&mdash;the opposite of BT. 
* **UF (used for)**&mdash;indicates the nonpreferred URL. Nonpreferred URLs no longer resolve or redirect to another URL. UF is the reciprocal of USE and means "don't use" the term following it.
* **USE**&mdash;indicates the preferred, resolving URL. "Use" the term following it.
* **RTET (related equivalent term)**&mdash;indciates two URLs that both resolve to the same website. Neither is preferred. 
* **RT (related term)**&mdash;indicates an association between two related terms when it seems helpful. 


# How do I make the Sheer site go?

### Step 1: Get elasticsearch and python 2.7


That is beyond the scope of this document. Be sure to install virtualenv and virtualenvwrapper!

http://virtualenvwrapper.readthedocs.org/en/latest/

### Step 2: Install Sheer

Check out the sheer Github project:
```
$ git clone https://github.com/cfpb/sheer.git
```
create a virtualenv for sheer:
```
$ mkvirtualenv sheer
```

The new virtualenv will activate right away. to activate it later on (say, in a new terminal session) use the command "workon sheer"

Install sheer into the virtualenv with the -e flag (which allows you to make changes to sheer itself):

```
$ pip install -e ~/path/to/sheer
```

Install sheer's python requirements:

```
$ pip install -r ~/path/to/sheer/requirements.txt
```

You should now be able to run the sheer command:
```
$ sheer

usage: sheer [-h] [--debug] {inspect,index,serve} ...
sheer: error: too few arguments
```

That means it's working!

### Step 3: Explore the demo



1) check out this here repo into some directory on your machine
2) cd [checkout directory]
3) do this

```
sheer index
```



```
$ sheer serve
```

And browse to http://localhost:7000

The API is at http://localhost:7000/api/v1/q/urls.json

Enjoy!


# A Tip of the Hat

A tip of the hat to Marilyn Kercher. She started this list many years ago and took it as her personal mission to ensure you can find information from any government website&mdash;including those that don't end in .gov or .mil&mdash;when you search on [USA.gov](http://www.usa.gov). She would be thrilled to learn that this list is now open for anyone to access.

We welcome comments and additions. [Contribute](/CONTRIBUTING.md) directly to this list or email us at <search@support.digitalgov.gov>.
