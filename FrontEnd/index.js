fetch('https://jx16zysyf2.execute-api.eu-north-1.amazonaws.com/visitor_count', {
    method: 'POST'
})
    .then(response => response.json())
    .then(data => {
        // Update the website
        document.getElementById('visitor-counter').innerText = data.VisitorCount;
    })
    .catch(error => {
        console.error('Error:', error);
    });