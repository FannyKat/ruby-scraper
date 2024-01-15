import { fetch } from 'wix-fetch';

export async function fetchAds() {
  let url = "https://art-coma.fr/annonces.json";
  return fetch(url, {"method": "get"})
      .then((response) => {
          if(response.ok) {
              return response.json();
          } else {
              return Promise.reject("Fetch did not succeed");
          }
      })
};