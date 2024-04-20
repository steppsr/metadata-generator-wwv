# metadata-generator-wwv
Bash script to generate metadata JSON files for the Wacky Wonky Vixens NFT Collection

### Assumptions

* Project folder does not have spaces. You should use underscores or no spaces.
* folder & file structure as follows:

  ```
  \project
      \deploy
          \images
          \metadata
          banner.png
          icon.png
          license.md
      metadata.csv
  ```

  The `\images` folder will contain the images for each NFT. Script is based on .png so you may need to change if you've used another image type.

  The `\metadata` folder will contain the JSON files for each NFT.

* The metadata JSON files will use the `metadata.csv` file to determine the filenames, NFT names, and an attribute.
* You will need to create your own UUID for the collection ID. You can use this website if needed: https://www.uuidgenerator.net/
* You will need the URI for the icon.png file, meaning it should already be uploaded to IPFS before running this script.
* You will need the URI for the banner.png file, meaning it should already be uploaded to IPFS before running this script.
