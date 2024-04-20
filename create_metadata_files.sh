#!/bin/bash

appdir=`pwd`
updir="./deploy/metadata"
cd $updir
c=0

# loop through each line and create metadata file - Sample data in metadata.csv file below
# 000.png,#000 - Bubbles McFizz,Luck=1
input="$appdir/metadata.csv"
while IFS= read -r line
do
    c=$(($c+1))
    this_file=$(echo "$line" | cut --fields 1 --delimiter=,)
    this_name=$(echo "$line" | cut --fields 2 --delimiter=,)
    this_attr_1=$(echo "$line" | cut --fields 3 --delimiter=,)
    this_attr_1_name=$(echo "$this_attr_1" | cut --fields 1 --delimiter==)
    this_attr_1_value=$(echo "$this_attr_1" | cut --fields 2 --delimiter==)

	filename=$(basename -- "$this_file")
	extension="${filename##*.}"
	filename="${filename%.*}"

    # build the collection json first
    md_col_name="Wacky Wonky Vixens"
    md_col_desc="Welcome to the zaniest, most whimsical corner of the NFT universe – behold the Wacky Wonky Vixens collection! Prepare to be whisked away on a rollercoaster ride of eccentricity and charm as you delve into a kaleidoscope of color and character. In this wondrous world, each NFT is a quirky masterpiece, a burst of vibrant hues and playful designs that will tickle your fancy and ignite your imagination. Meet our wacky vixens, the epitome of eccentricity and charm, each one bursting with personality and mischief. From the mischievous twinkle in their eyes to the whimsical tilt of their hats, these vixens are more than just digital art – they're companions on a journey through the wackiest corners of your mind. Whether you're a collector or a connoisseur of the curious, there's a wacky vixen waiting to steal your heart and brighten your day. So come one, come all, and join us on this wild and wacky adventure. Let your imagination run wild and your spirits soar as you explore the enchanting world of the Wacky Wonky Vixens – where the only limit is your own imagination!"
    md_col_id="2f35bc0c-e57b-11ed-97d9-ab322045acb3"

    # YOU NEED TO UPLOAD THE ICON and BANNER IMAGES TO NFT.STORAGE BEFORE RUNNING THIS SCRIPT - ADD THE URLS INTO THE VALUE FIELDS BELOW.

	# icon image (typically 350x350 pixels)
	md_col_att1_label="icon"
	md_col_att1_value="https://bafkreif2e55ad5clgg5poqftyofdxckj2eayn3ormo27vxjqocumhxpoti.ipfs.nftstorage.link"
	# banner image (typically 4:1 ratio)
	md_col_att2_label="banner"
	md_col_att2_value="https://bafybeicjhlduvuosdoi6mdqzxomshavarkqny5mubzccpx4z3kwyyldr7a.ipfs.nftstorage.link"
    md_col_att3_label="twitter"
    md_col_att3_value="@steppsr"
    md_col_att4_label="website"
    md_col_att4_value="https://xchdev.com"

    # make a json object for the collection metadata
    json_collection=`jq -n --arg id "$md_col_id" --arg name "$md_col_name" --argjson attributes "[$images]" '$ARGS.named' `
    json_collection=`echo $json_collection | jq	'.attributes += [{"type":"'"$md_col_att1_label"'", "value": "'"$md_col_att1_value"'"}]'`
    json_collection=`echo $json_collection | jq	'.attributes += [{"type":"'"$md_col_att2_label"'", "value": "'"$md_col_att2_value"'"}]'`
    json_collection=`echo $json_collection | jq	'.attributes += [{"type":"'"$md_col_att3_label"'", "value": "'"$md_col_att3_value"'"}]'`
    json_collection=`echo $json_collection | jq	'.attributes += [{"type":"'"$md_col_att4_label"'", "value": "'"$md_col_att4_value"'"}]'`

    # build the main json file
    format="CHIP-0007"
    imgtitle="$md_col_name: $this_name"
    imgdesc="Embrace the Wacky, Embody the Wonky: Meet the Vixens of Whimsy!"
    minter="bash script"
    #sensitivity. Should be true or false DO NOT wrap in double quotes. The value needs to be boolean, not string for CHIP-0007
    sens=false

    image_json=`jq -n --arg format "$format" --arg name "$imgtitle" --arg description "$imgdesc" --arg minting_tool "$minter" --argjson sensitive_content $sens --argjson collection "$json_collection" '$ARGS.named' --argjson attributes "[]" `
    image_json=`echo $image_json | jq '.attributes += [{"trait_type": "'"$this_attr_1_name"'", "value": "'"$this_attr_1_value"'"}]'`

    printf "$image_json" > "$filename.json"
	echo "$c - $filename.json $myname"

done < "$input"
cd $appdir
