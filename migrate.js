const algoliasearch = require('algoliasearch');

// Initialize the Algolia clients with your credentials
const sourceClient = algoliasearch('sourceApplicationID', 'sourceAPIKey');
const destinationClient = algoliasearch(
  'destinationApplicationID',
  'destinationAPIKey',
);

// Initialize the source and destination indices
const sourceIndex = sourceClient.initIndex('v1Product');
const destinationIndex = destinationClient.initIndex('v2Product');

const searchParams = {
  hitsPerPage: 1000,
  attributesToRetrieve: ['*'],
};

async function migrateRecords() {
  let page = 0;
  let nbPages = 0;
  let records = [];

  do {
    const { hits, nbPages: totalNbPages } = await sourceIndex.search('', {
      ...searchParams,
      page,
    });
    records.push(...hits);
    nbPages = totalNbPages;
    page++;
  } while (page < nbPages);

  await destinationIndex.saveObjects(records);

  console.log('Migration completed successfully!');
}

migrateRecords().catch((error) => console.error(error));
