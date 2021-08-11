# TodoList

---

## 사용 기술

- #### PagingKit, TweeTextField

- #### Delegate Pattern, Property Observer



## 처리해야 할 것

- #### Todo Array 인덱스와 TableView Section 인덱스가 다름(당연) -> 맞춰서 Todo 데이터 삭제 시 테이블뷰 셀에서도 제거하기...

- #### nil 값 validation

- #### Todo Array를 Appdelegation으로 옮기기



## 2020 08 11

- #### Todo Detail 팝업 데이터 전달

- #### HistoryViewController 구현

- #### tableView Section 별 row에 접근 방법 터득(?)

  ~~~ swift
  // 선택된 아이템 섹션 저장
  var selectedSection = indexPath.section
  // 선택된 아이템 로우 저장
  var selectedIndex = indexPath.row
  
  ...
  
  // 접근
  todo[selectedSection].rows[selectedIndex]
  ~~~

- #### DeliveryDataProtocol 파라미터 타입을 Any로 변경하여 두 컨트롤러에서 사용

  ~~~ swift
  func deliveryData(_ data: Any) {
    			// Todo Detail 팝업 뷰에서 완료 버튼을 클릭하였을 경우
          if data as? Bool == true {
              AppDelegate.todoHistory.append(todo[selectedSection].rows[selectedIndex])
            	// 수정해야할 부분 ㅠㅠ
              self.todoData.remove(at: todo[selectedSection].rows[selectedIndex].index)
              changeTableView()
          }
    			// Todo 추가 팝업 뷰에서 확인 버튼을 클릭하였을 경우
          else {
              let getData = data as! Todo
              
              self.todoData.append(Todo(todo: getData.todo, date: getData.date, index: todoData.count))
              changeTableView()
          }
  }
  ~~~


## 2020 08 09

- #### UserDefault로 Todo 목록 저장 및 Todo 생성 시 델리게이트 패턴으로 데이터 전달

  - UserDefault

    ~~~ swift
    // TodoList 저장
    fileprivate func saveTodoList() {
            UserDefaults.standard.set(try? PropertyListEncoder().encode(todoData), forKey:"todoList")
    }
    
    // TodoList 가져오기
    fileprivate func getTodoList() {
        if let data = UserDefaults.standard.value(forKey:"todoList") as? Data {
            let getData = try! PropertyListDecoder().decode([Todo].self, from: data)
            self.todoData = getData
            changeTableView()
        }
    }
    ~~~

  - Delegate Pattern

    ~~~ swift
    // 프로토콜 생성
    protocol DeliveryDataProtocol: class {
        func deliveryData(_ data: Todo)
    }
    
    // 새로운 뷰를 띄우고 그 뷰를 통해 데이터를 전달받는 뷰 컨트롤러
    class MainViewController: UITableViewController, DeliveryDataProtocol {
      ...
      
      @IBAction func didTabAddButton(_ sender: Any) {
            ...
            let popup = storyboard.instantiateViewController(identifier: "AddToDoViewController") as! AddToDoViewController
            popup.modalTransitionStyle = .crossDissolve
            popup.modalPresentationStyle = .overFullScreen
                
        		// delegate 설정 !!
            popup.delegate = self
    
            self.present(popup, animated: true)
        	  ...
      }
      
      // 가져온 데이터를 Todo array에 추가하고 테이블뷰 갱신
      func deliveryData(_ data: Todo) {
            self.todoData.append(data)
            changeTableView()
      }
    }
    
    // 데이터를 전달하는 뷰 컨트롤러
    class AddToDoViewController: UIViewController {
          // delegate 선언
      	  weak var delegate: DeliveryDataProtocol?
      
          @IBAction func didTabAddBtn(_ sender: Any) {
            // 버튼 클릭 시 입력한 데이터를 델리게이트 패턴을 통해 데이터 전달
            delegate?.deliveryData(Todo(todo: self.todoLabel.text!, date: parseDate(self.dateLabel.text!)))
        }
    }
    ~~~

    

## 2020 08 08

- #### Todo 날짜에 따른 TableView Section 구분

  ~~~ swift
  // 섹션 그룹화를 위한 구조체 생성
  struct GroupedSection<SectionItem : Hashable, RowItem> {
  
      var sectionItem : SectionItem
      var rows : [RowItem]
  
      static func group(rows : [RowItem], by criteria : (RowItem) -> SectionItem) -> [GroupedSection<SectionItem, RowItem>] {
          let groups = Dictionary(grouping: rows, by: criteria)
          return groups.map(GroupedSection.init(sectionItem:rows:))
      }
  }
  
  // MainViewController
  
  // todo array 생성
  var todo = [GroupedSection<Date, Todo>]()
  
  ...
     // 섹션에 맞게 todo 데이터들 분류 
     self.todo = GroupedSection.group(rows: todoData, by: { firstDayOfMonth(date: $0.date) })
     // 섹션 (달) 오름차순 정렬
     self.todo.sort { lhs, rhs in lhs.sectionItem < rhs.sectionItem }
  ~~~

  

## 2020 08 06

- #### Closure를 사용하여 테이블뷰 셀의 버튼 기능(셀 삭제) 구현

  ~~~ swift
  class ToDoCell: UITableViewCell {
    ...
    // 클로저 정의
    var delete: (() -> ()) = {}
    
    // 삭제 버튼 클릭 시 delete() 클로저 호출
    @IBAction func didTapDelete(_ sender: Any) {
          delete()
    }
  }
  
  // MainViewController
  class MainViewController: UITableViewController {
    ...
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      ...
      // 셀 삭제 버튼 클릭 시 삭제 진행을 묻는 메소드 호출
      cell.delete = { [unowned self] in
              self.showDeleteWarningMessage(index: indexPath.row)
      }
   	}
  }
  ~~~

## 2020 08 05

#### PagingKit를 사용하여 메인 뷰 구성 (상단 메뉴 및 메뉴에 따른 뷰 전환)
<img src= "https://user-images.githubusercontent.com/44960073/128829875-4682dcf3-6c5c-44b5-8578-d8b128d5f06c.gif"  width="200" height="400"/>
