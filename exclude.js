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
  const mapping = {
    meta_description: 'm_description',
    meta_keywords: 'keywords',
    meta_title: 'title',
  };

  // Exclude fields from v1 -> v2.
  const excludedFields = ['availability_type', 'avg_rating', 'crushable'];

  const transformedRecord = {};

  Object.keys(record).forEach((fieldName) => {
    if (!excludedFields.includes(fieldName)) {
      const destinationFieldName = mapping[fieldName] || fieldName;
      transformedRecord[destinationFieldName] = record[fieldName];
    }
  });

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

  //   await destinationIndex.saveObjects(transformedRecords, {
  //     autoGenerateObjectIDIfNotExist: true,
  //   });

  //   console.log('Migration completed successfully!');
}

migrateRecords().catch((error) => console.error(error));
