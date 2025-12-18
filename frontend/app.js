fetch('https://jx16zysyf2.execute-api.eu-north-1.amazonaws.com/visitor_count', {
    method: 'POST'
})
    .then(response => response.json())
    .then(data => {
        // Update the Total Views counter
        const totalElement = document.getElementById('total-counter');
        if (totalElement) {
            totalElement.innerText = data.count;
        }

        // Update the Unique Visitors counter
        const uniqueElement = document.getElementById('unique-counter');
        if (uniqueElement) {
            uniqueElement.innerText = data.unique_count;
        }
    })
    .catch(error => {
        console.error('Error fetching visitor count:', error);
    });