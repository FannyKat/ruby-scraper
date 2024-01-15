import { fetchAds } from "backend/fetchAds";

$w.onReady(function () {
	leboncoinAds()
});

export function leboncoinAds(event) {
	const myGallery = $w('#gallery1');

	fetchAds()
		.then((json) => {
			myGallery.items = json.map(item => {
			return {
				"src": item.img_url,
				"title": item.titre,
				"description": item.prix,
				"link": item.url
			};
			});
		})
		.catch(error => {
				console.error("Error fetching ads:", error);
			});
}
