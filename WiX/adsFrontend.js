import { fetchAds } from "backend/fetchAds"; 

$w.onReady(function () {
	leboncoinAds()
});

export function leboncoinAds(event) {
	const myGallery = $w('#gallery1');

	fetchAds()
		.then((json) => {
			console.log(json);
			
			myGallery.items = json.map(item => {
			return {
				"src": item.img_url,
				"description": `${item.titre} - ${item.prix}`,
			};
			});
	});
}