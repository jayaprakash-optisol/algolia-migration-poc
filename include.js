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

function transformRecord(record) {
  // Fields to be renamed
  const mapping = {
    meta_description: 'm_description',
    meta_keywords: 'keywords',
    meta_title: 'title',
  };

  // Include new fields to v2.
  const newFields = ['barcode', 'taxon_id', 'brand_id'];

  const transformedRecord = {};

  Object.keys(record).forEach((fieldName) => {
    const destinationFieldName = mapping[fieldName] || fieldName;
    transformedRecord[destinationFieldName] = record[fieldName];
  });

  // Add new fields to the new schema
  for (const field of newFields) {
    transformedRecord[field] = null; // for testing -> Initialize new fields to null
  }

  return transformedRecord;
}

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

  const transformedRecords = records.map(transformRecord);
  console.log('transformedRecords', transformedRecords);

  await destinationIndex.saveObjects(transformedRecords, {
    autoGenerateObjectIDIfNotExist: true,
  });

  console.log('Migration completed successfully!');
}

migrateRecords().catch((error) => console.error(error));
