/* eslint-disable no-undef */
sap.ui.define(
  ["sap/ui/base/Object"],
  /**
   * @param {typeof sap.ui.base.Object} BaseObject
   */ function (BaseObject) {
    const Tree = BaseObject.extend("allocations.ext.fragment.Tree", {
      constructor: function () {},
      render: function (domContainer, valueContainer) {
        const e = React.createElement;

        const rootNodes = [
          {
            value: "NT1",
            label: "Parent 1",
            isNode: true,
          },
          {
            value: "NT2",
            label: "Node 2",
          },
        ];

        const Operator = ({ onChange }) => {
          const operators = ["Equals", "Greater", "Less", "Contains"];

          return e(
            "select",
            { onChange: (e) => onChange(e.target.value)},
            operators.map((op) =>
              e(
                "option",
                {
                  value: op,
                },
                op
              )
            )
          );
        };

        const Selection = ({ values, setOperator }) => {
          if (values.length < 1) return null;
          return e(
            "div",
            { class: "selected-list" },
            values.map((value) =>
              e("label", null, e(Operator, { onChange: (op) => {
                setOperator(value, op)} }), e("span", null, value))
            )
          );
        };

        const Expand = ({ onExpand, expanded }) => {
          const onClick = () => {
            onExpand();
          };
          return e(
            "button",
            { class: "expand", onClick },
            expanded ? "-" : "+"
          );
        };

        const TreeItem = ({ node, onChangeSelection, onExpand, expanded, selected }) => {
          const content = [];
          if (node.isNode) {
            content.push(
              e(Expand, {
                onExpand: () => {
                  onExpand(node.value);
                },
                expanded,
              })
            );
          }
     
          content.push(
            e("input", {
              type: "checkbox",
              value: node.value,
              checked: selected,
              onChange: onChangeSelection,
            })
          );
     
          content.push(e("span", null, node.label));

          return e("label", null, ...content);
        };

        const Tree = () => {
          const [topNodes, setTopNodes] = React.useState([]);
          const [childrenFor, setChildrenFor] = React.useState({});
          const [expandedValues, setExpandedValues] = React.useState([]);
          const [selectedValues, setSelectedValues] = React.useState([]);
          const [operatorFor, setOperatorFor] = React.useState({});
          const [loading, setLoading] = React.useState(true);

          const onChangeSelection = (e) => {
            const value = e.target.value;
            if (e.target.checked && !selectedValues.includes(value)) {
              setSelectedValues((state) => [...state, value]);
            } else {
              setSelectedValues((state) => state.filter((v) => v !== value));
            }
          };

          React.useEffect(() => {
            setTimeout(() => {
              setLoading(false);
              setTopNodes(rootNodes);
            }, 500);
          }, []);

          React.useEffect(() => {
            valueContainer.setAttribute(
              "value",
              JSON.stringify(selectedValues.map((v) => ({ LOW: v, OP: operatorFor[v] || 'Equals' })))
            );
          }, [selectedValues, operatorFor]);

          const onExpand = (parentName) => {
            if (expandedValues.includes(parentName)) {
              setChildrenFor((state) => ({ ...state, [parentName]: null }));
              setExpandedValues((state) =>
                state.filter((v) => v !== parentName)
              );
              return;
            }
            setExpandedValues((state) => [...state, parentName]);
            setLoading(true);
            setTimeout(() => {
              if (childrenFor[parentName]) return;
              const children = [
                { value: `${parentName}-v1`, label: `${parentName}-Child 1` },
                {
                  value: `${parentName}-v2`,
                  label: `${parentName}-Child 2`,
                  isNode: true,
                },
                { value: `${parentName}-v3`, label: `${parentName}-Child 3` },
              ];

              setChildrenFor((state) => ({ ...state, [parentName]: children }));

              setLoading(false);
            }, 500);
          };

          const setOperator = (value, op) => {
            setOperatorFor(state => ({...state, [value]: op }))
          };

          const renderNodes = (nodes) =>
            e(
              "ul",
              null,
              nodes?.map((node) =>
                e(
                  "li",
                  { key: node.value },
                  e(TreeItem, {
                    node,
                    onChangeSelection,
                    onExpand,
                    expanded: expandedValues.includes(node.value),
                    selected: selectedValues.includes(node.value),
                  }),
                  renderNodes(childrenFor[node.value])
                )
              )
            );

          const content = [];
          if (loading) {
            content.push(e("div", { class: "loading" }, "Loading..."));
          }
          content.push(e(Selection, { values: selectedValues, setOperator }));
          content.push(e("div", { class: "list" }, renderNodes(topNodes)));

          return e("div", { class: "root" }, ...content);
        };

        ReactDOM.render(e(Tree), domContainer);
      },
    });

    return Tree;
  }
);
