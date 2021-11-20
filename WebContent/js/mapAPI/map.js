function myLocation() {

	// geolocation
	navigator.geolocation.getCurrentPosition((position) => {
		let latitude = position.coords.latitude;
		let longitude = position.coords.longitude;

		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
			mapOption = {
				center: new kakao.maps.LatLng(latitude, longitude), // 지도의 중심좌표
				level: 1 // 지도의 확대 레벨
			};

		// 지도를 생성합니다    
		var map = new kakao.maps.Map(mapContainer, mapOption);

		// 주소-좌표 변환 객체를 생성합니다
		var geocoder = new kakao.maps.services.Geocoder();

		// 현재 지도 중심좌표로 주소를 검색해서 지도 좌측 상단에 표시합니다
		searchAddrFromCoords(map.getCenter(), displayCenterInfo);

		// 중심 좌표나 확대 수준이 변경됐을 때 지도 중심 좌표에 대한 주소 정보를 표시하도록 이벤트를 등록합니다
		kakao.maps.event.addListener(map, 'idle', function() {
			searchAddrFromCoords(map.getCenter(), displayCenterInfo);
		});

		function searchAddrFromCoords(coords, callback) {
			// 좌표로 행정동 주소 정보를 요청합니다
			geocoder.coord2RegionCode(coords.getLng(), coords.getLat(), callback);
		}

		function searchDetailAddrFromCoords(coords, callback) {
			// 좌표로 법정동 상세 주소 정보를 요청합니다
			geocoder.coord2Address(coords.getLng(), coords.getLat(), callback);
		}

		// 지도 좌측상단에 지도 중심좌표에 대한 주소정보를 표출하는 함수입니다
		function displayCenterInfo(result, status) {
			if (status === kakao.maps.services.Status.OK) {
				var infoDiv = document.getElementById('centerAddr');
				
				for (var i = 0; i < result.length; i++) {
					// 행정동의 region_type 값은 'H' 이므로
					if (result[i].region_type === 'H') {
						infoDiv.innerHTML = result[i].address_name;
						document.querySelector("#address").value = result[i].address_name;
						break;
					}
				}
			}
		}


		// 원
		// 지도에 표시할 원을 생성합니다
		var circle = new kakao.maps.Circle({
			center: new kakao.maps.LatLng(latitude, longitude),  // 원의 중심좌표 입니다 
			radius: 3000, // 미터 단위의 원의 반지름입니다 
			strokeWeight: 4, // 선의 두께입니다 
			strokeColor: '#75B8FA', // 선의 색깔입니다
			strokeOpacity: 1, // 선의 불투명도 입니다 1에서 0 사이의 값이며 0에 가까울수록 투명합니다
			strokeStyle: 'line', // 선의 스타일 입니다
			fillColor: '#CFE7FF', // 채우기 색깔입니다
			fillOpacity: 0.4  // 채우기 불투명도 입니다   
		});

		// 지도에 원을 표시합니다 
		circle.setMap(map);



		// geolocationToMapMark
		var locPosition = new kakao.maps.LatLng(latitude, longitude), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
			message = '<div style="width:auto;">여기가 맞을까요?</div>'; // 인포윈도우에 표시될 내용입니다

		// 마커와 인포윈도우를 표시합니다
		displayMarker(locPosition, message);


		// 지도에 마커와 인포윈도우를 표시하는 함수입니다
		function displayMarker(locPosition, message) {

			// 마커를 생성합니다
			var marker = new kakao.maps.Marker({
				map: map,
				position: locPosition
			});

			var iwContent = message, // 인포윈도우에 표시할 내용
				iwRemoveable = true;

			// 인포윈도우를 생성합니다
			var infowindow = new kakao.maps.InfoWindow({
				content: iwContent,
				removable: iwRemoveable
			});

			// 인포윈도우를 마커위에 표시합니다 
			infowindow.open(map, marker);

			// 지도 중심좌표를 접속위치로 변경합니다
			map.setCenter(locPosition);
		}
	}, (err) => {
		alert("위치 정보를 불러오는데 오류가 발생하였습니다.");
	});
}