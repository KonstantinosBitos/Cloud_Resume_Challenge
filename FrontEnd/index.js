fetch('https://ey7gl2zki2.execute-api.eu-north-1.amazonaws.com/MyFirstStage/', {
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